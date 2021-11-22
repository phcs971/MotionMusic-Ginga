//
//  UIModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AVFoundation

extension HomeViewController {
    
    func checkDebugMode() {
        if DEBUG_MODE {
            FpsLabel.alpha = 1
            FpsLabel.isHidden = false
        } else {
            FpsLabel.alpha = 0
            FpsLabel.isHidden = true
        }
    }
    
    @IBAction func onSwitchCamera(_ sender: Any) {
        guard let currentInput: AVCaptureInput = session.inputs.first else { return }
        
        session.beginConfiguration()
        session.removeInput(currentInput)
        
        if (currentInput as! AVCaptureDeviceInput).device.position == .front {
            self.createInput(position: .back)
            frontCamera = false
        } else {
            self.createInput(position: .front)
            frontCamera = true
        }
        session.commitConfiguration()
    }
    
    @IBAction func onMic(_ sender: Any) {
        self.microphone.toggle()
    }
    
    @IBAction func onSeeAreas(_ sender: Any) {
        self.seeAreas.toggle()
    }
    
    @IBAction func onTimer(_ sender: Any) {
        
    }
    
    @IBAction func onBottomReturn(_ sender: Any) {
        self.state = .Normal
    }
}
