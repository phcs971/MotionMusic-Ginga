//
//  SoundsModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AudioKit
import AVFoundation

extension HomeViewController {
    func startAudio() {
        engine.output = sampler
        do {
            try engine.start()
        } catch {
            printError("Start AudioKit", error)
        }
    }
    
    func initLoops() {
        for controller in soundControllers.filter({ $0.type == .Toggle }) {
            controller.player = try? AVAudioPlayer(contentsOf: controller.audio.url)
            controller.player?.setVolume(0, fadeDuration: 0)
            controller.player?.numberOfLoops = -1
            controller.player?.prepareToPlay()
            controller.player?.play()
        }
    }
    
    func playSound(_ controller: SoundButtonController, point: CGPoint) {
        if controller.type == .Toggle {
            setLoop(controller)
        } else {
            sampler.play(noteNumber: MIDINoteNumber(controller.note))
        }
        if let animation = controller.animation {
            var p = point
            if let offset = controller.animationOffset { p = CGPoint(x: point.x + offset.x, y: point.y + offset.y) }
            self.createAnimation(point: p, animation: animation)
        }
    }
    
    func stopSound(_ controller: SoundButtonController, point: CGPoint) {
        if controller.type == .Toggle {
            setLoop(controller, status: false)
        }
    }
    
    func setLoop(_ controller: SoundButtonController, status: Bool = true) {
        controller.player?.setVolume(status ? 1 : 0, fadeDuration: 0)
        controller.isPlaying = status
        createSoundButtons()
    }
    
    func loadFiles() {
        do {
            let files = soundControllers.filter {$0.type != .Toggle }.compactMap { $0.audio }
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
