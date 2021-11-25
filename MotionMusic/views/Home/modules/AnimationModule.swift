//
//  AnimationModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import Lottie

extension HomeViewController {
    func createAnimation(point: CGPoint, controller: SoundButtonController, size: CGFloat = 240) {
        if !effect.showAnimation { return }
        if let animation = controller.animation {
            
            let animationName = "\(self.effect.id)_\(animation)"
            DispatchQueue.main.async {
                controller.animationView = AnimationView(name: animationName)
                
                let fixedPoint = self.percentToFramePoint(percent: point)
                controller.animationView?.frame = CGRect(x: fixedPoint.x - size / 2, y: fixedPoint.y - size / 2, width: size, height: size)
                controller.animationView?.contentMode = .scaleAspectFit
                controller.animationView?.loopMode = controller.type == .Toggle ? .loop : .playOnce
                
                if let animationView = controller.animationView {
                    self.AnimationsView.addSubview(animationView)
                    self.animations.append(animationView)
                    
                    animationView.play { _ in
                        UIView.animate(withDuration: 0.2) {
                            animationView.alpha = 0
                        } completion: { _ in
                            if controller.type != .Toggle {
                                self.removeAnimation(controller)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeAnimation(_ controller: SoundButtonController) {
        DispatchQueue.main.async {
            controller.animationView?.stop()
            controller.animationView?.removeFromSuperview()
            self.animations.removeAll { $0.superview == nil }
        }
    }
}
