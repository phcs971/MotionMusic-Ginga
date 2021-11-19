//
//  SoundsModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AudioKit

extension HomeViewController {
    func startAudio() {
        engine.output = sampler
        do {
            try engine.start()
        } catch {
            printError("Start AudioKit", error)
        }
    }
    
    func playSound(_ controller: SoundButtonController) {
        sampler.play(noteNumber: MIDINoteNumber(controller.note))
    }
    
    func stopSound() {
        sampler.stop()
    }
    
    func loadFiles() {
        do {
            let files = soundControllers.compactMap { $0.audio }
            try sampler.loadAudioFiles(files)
        } catch {
            printError("Load Files", error)
        }
    }
    
    func stopAudio() {
        engine.stop()
    }
    
    
    func onClap(point: CGPoint) {
        if let controller = soundControllers.first(where: { $0.type == .Clap }) {
            playSound(controller)
            self.createAnimation(point: point, animation: "Clap")
//            self.createAnimation(point: point, animation: "fireworks")
        }
    }
}
