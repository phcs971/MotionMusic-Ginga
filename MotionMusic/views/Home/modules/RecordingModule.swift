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
            UIView.animate(withDuration: 0.5) {
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
            let temp = getTempURL(fileExtension: "mp4")
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
            self.isRecording = true
            self.prevSeeAreas = self.seeAreas
            self.seeAreas = false
            recorder.startRecording { error in
                guard error == nil else {
                    self.isRecording = false
                    self.seeAreas = self.prevSeeAreas
                    return printError("Start Recording", error)
                }
                self.microphone = self.recorder.isMicrophoneEnabled

                print("Started Recording!")
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
            DispatchQueue.main.async { self.performSegue(withIdentifier: "review", sender: self) }
            

        })
    }
}
