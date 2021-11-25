//
//  RecordingModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AVFoundation
import ReplayKit

extension HomeViewController {
    func updateRecordingUI() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.isRecording ? 0.4 : 0) {
                if self.isRecording {
                    self.TopMenuBackground.alpha = 0
                    self.uiLabels.forEach { $0.alpha = 0 }
                    self.uiButtons.forEach { $0.alpha = 0 }
                } else {
                    self.TopMenuBackground.alpha = 1
                    self.uiLabels.forEach { $0.alpha = 1 }
                    self.uiButtons.forEach { $0.alpha = 1 }
                }
            } completion: { _ in
                if self.isRecording {
                    self.TopMenuBackground.isHidden = true
                } else {
                    self.TopMenuBackground.isHidden = false
                }
            }
        }
    }
    
    @objc @IBAction func startStopRecording(_ sender: Any) {
        if isRecording {
            self.stopAllSounds()
            let temp = getTempURL(fileExtension: "mp4")
            self.loadingResult = true
            let final = getURL(for: .documentDirectory, fileExtension: "mov")
            recorder.stopRecording(withOutput: temp) { error in
                guard error == nil else { return printError("Stop Recording") }
                DispatchQueue.main.async { self.stop() }
                print("Finished Recording!")
                self.isRecording = false
                let item = AVPlayerItem(asset: AVAsset(url: temp))
                if let size = item.asset.videoSize {
                    let rect = CGRect(x: 0, y: size.height * self.yFactor, width: size.width, height: size.height * (1 - self.yFactor))
                    self.transformVideo(item: item, outputUrl: final, cropRect: rect)
                    self.seeAreas = self.prevSeeAreas
                }
            }
        } else {
            guard recorder.isAvailable else { return printError("Recorder Unavailable") }
            
            recorder.isMicrophoneEnabled = microphone
            self.prevSeeAreas = self.seeAreas
            self.seeAreas = false
            self.isRecording = true
            askPermission {
                if self.timerNumber != 0 {
                    
                    var runCount = self.timerNumber
                    self.TimerView.isHidden = false
                    self.TimerNumberLabel.text = String(runCount)
                    
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        runCount -= 1
                        if runCount == 0 {
                            timer.invalidate()
                            self.TimerView.isHidden = true
                            self.startRecording()
                        } else {
                            self.TimerNumberLabel.text = String(runCount)
                        }
                    }
                } else {
                    self.startRecording()
                }
                
            }
        }
    }
    fileprivate func startRecording() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.recorder.startRecording { error in
                guard error == nil else {
                    self.isRecording = false
                    self.seeAreas = self.prevSeeAreas
                    return printError("Start Recording", error)
                }
                
                self.microphone = self.recorder.isMicrophoneEnabled
                
                self.recordingView.startPulsing()
                print("Started Recording!")
            }
        }
    }
    
    func askPermission(completionHandler: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.recorder.startRecording { error in
                guard error == nil else {
                    self.isRecording = false
                    self.seeAreas = self.prevSeeAreas
                    return printError("Start Recording (PERMISSION)", error)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.recorder.stopRecording { _, error in
                        guard error == nil else { return printError("Stop Recording (PERMISSION)") }
                        DispatchQueue.main.async { completionHandler() }
                    }
                }
            }
        }
    }
    
    func transformVideo(item: AVPlayerItem, outputUrl: URL, cropRect: CGRect) {
        let cropScaleComposition = AVMutableVideoComposition(asset: item.asset, applyingCIFiltersWithHandler: {request in
            let cropFilter = CIFilter(name: "CICrop")! //1
            cropFilter.setValue(request.sourceImage, forKey: kCIInputImageKey) //2
            cropFilter.setValue(CIVector(cgRect: cropRect), forKey: "inputRectangle")
            
            let imageAtOrigin = cropFilter.outputImage!.transformed(by: CGAffineTransform(translationX: -cropRect.origin.x, y: -cropRect.origin.y)) //3
            
            request.finish(with: imageAtOrigin, context: nil) //4
        })
        
        cropScaleComposition.renderSize = cropRect.size //5
        item.videoComposition = cropScaleComposition  //6
        
        let exporter = AVAssetExportSession(asset: item.asset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = cropScaleComposition
        exporter.outputURL = outputUrl
        exporter.outputFileType = .mov
        
        self.outputUrl = outputUrl
        
        exporter.exportAsynchronously(completionHandler: {
            self.loadingResult = false
            DispatchQueue.main.async { self.performSegue(withIdentifier: "review", sender: self) }
            
            
        })
    }
    
}
