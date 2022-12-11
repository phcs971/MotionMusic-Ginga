//
//  SoundsModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AVFoundation

extension HomeViewController {
    
    func loadFiles() {
        var players = [AVAudioPlayer]()
        for controller in soundControllers.filter({ $0.type == .Toggle }) {
            if let player = controller.player {
                player.numberOfLoops = -1
                player.setVolume(0, fadeDuration: 0)
                players.append(player)
            }
        }
        players.forEach { $0.play() }
    }
    
    func playSound(_ controller: SoundButtonController, point: CGPoint) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if controller.type == .Toggle {
            setLoop(controller)
        } else {
            controller.play()
        }
        if let _ = controller.animation {
            var p = point
            if let offset = controller.animationOffset { p = CGPoint(x: point.x + offset.x, y: point.y + offset.y) }
            self.createAnimation(point: p, controller: controller)
        }
    }
    
    func stopAllSounds() {
        for controller in soundControllers.filter({ $0.type == .Toggle }) {
            stopSound(controller)
        }
    }
    
    func stopSound(_ controller: SoundButtonController) {
        if controller.type == .Toggle {
            setLoop(controller, status: false)
            removeAnimation(controller)
        }
    }
    
    func setLoop(_ controller: SoundButtonController, status: Bool = true) {
        controller.player?.setVolume(status ? 1 : 0, fadeDuration: 0)
        controller.isPlaying = status
        createSoundButtons()
    }
    
    func onClap(point: CGPoint) {
        if let controller = soundControllers.first(where: { $0.type == .Clap }) {
            playSound(controller, point: point)
        }
    }
}
