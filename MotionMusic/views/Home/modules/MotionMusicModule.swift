//
//  MotionMusicModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit

extension HomeViewController {
    
    func updateSoundControllers() {
        soundControllers = music.buttons.compactMap({ SoundButtonController($0) })
        
        loadFiles()
        createSoundButtons()
    }
    
    func createSoundButtons() {
        //        self.busy = true
        self.SoundButtonsView.subviews.forEach { $0.removeFromSuperview() }
        let width = self.SoundButtonsView.frame.width
        let height = self.SoundButtonsView.frame.height
        for controller in soundControllers {
            if (controller.type == .Clap) { continue }
            let x = CGFloat(controller.position.x * width)
            let y = CGFloat(controller.position.y * height)
            let radius = CGFloat(controller.radius * width)
            let size = 2 * radius
            let button = UIView(frame: CGRect(x: x - radius, y: y - radius, width: size, height: size))
            button.backgroundColor = controller.color
            button.alpha = 0.5
            button.layer.cornerRadius = radius
            if (controller.type == .Toggle) {
                let imgView = UIImageView()
                imgView.image = UIImage(systemName: controller.isPlaying ? "play.fill" : "pause.fill")
                imgView.tintColor = .white.withAlphaComponent(0.9)
                let imgSize = 0.5 * size
                let padding = 0.25 * size
                imgView.frame = CGRect(x: padding, y: padding, width: imgSize, height: imgSize)
//                imgView.center = button.center
                button.addSubview(imgView)
            }
            self.SoundButtonsView.addSubview(button)
        }
    }
    
    func checkAllPoints(points: [CGPoint]) {
        for controller in soundControllers {
            if controller.type == .Clap { continue }
            let (point, isIn) = checkPoints(points: points, controller: controller)
            if controller.type == .Toggle {
                if isIn {
                    if !controller.isIn && controller.lastTime.compare(Date().advanced(by: -0.5)) == .orderedAscending {
                        controller.enter()
                        if controller.isPlaying {
                            self.stopSound(controller)
                        } else {
                            self.playSound(controller, point: point!)
                        }
                    }
                } else {
                    controller.leave()
                }
            } else {
                if isIn {
                    let state = !controller.isIn
                    if state || controller.lastTime.compare(Date().advanced(by: -self.music.interval)) == .orderedAscending {
                        controller.enter()
                        playSound(controller, point: point!)
                    }
                } else {
                    controller.leave()
                }
            }
        }
    }
    
    func checkPoints(points: [CGPoint], controller: SoundButtonController) -> (CGPoint?, Bool) {
        for point in points {
            let f = self.SoundButtonsView.frame
            let fixedPoint = fixAxis(point)
            let x = fixedPoint.x
            let y = fixedPoint.y
            let dx = x - controller.position.x
            let dy = y - controller.position.y * (1 - yFactor)
            let dist = pow(dx * f.width, 2)  + pow(dy * f.height, 2)
            let radius = pow(controller.radius * f.width, 2)
            if dist <= radius {
                return (point, true)
            }
        }
        return (nil, false)
    }
    
}
