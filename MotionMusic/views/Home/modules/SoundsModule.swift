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
    
    func playSound(_ controller: SoundButtonController, point: CGPoint) {
        sampler.play(noteNumber: MIDINoteNumber(controller.note))
        if let animation = controller.animation {
            var p = point
            if let offset = controller.animationOffset { p = CGPoint(x: point.x + offset.x, y: point.y + offset.y) }
            self.createAnimation(point: p, animation: animation)
        }
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
            playSound(controller, point: point)
        }
    }
}
