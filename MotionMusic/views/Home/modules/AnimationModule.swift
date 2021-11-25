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
                controller.animationPoint = point
                controller.animationSize = size
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
                                self.removeAnimation(animationView)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateAllAnimations() {
        for controller in soundControllers.filter({ $0.type == .Toggle && $0.animationView != nil }) {
            updateAnimation(controller)
        }
    }
    
    func updateAnimation(_ controller: SoundButtonController) {
        self.removeAnimation(controller)
        self.createAnimation(point: controller.animationPoint!, controller: controller, size: controller.animationSize!)
    }
    
    func removeAnimation(_ controller: SoundButtonController) {
        DispatchQueue.main.async {
            controller.animationView?.stop()
            controller.animationView?.removeFromSuperview()
            controller.animationView = nil
//            self.animations.removeAll { $0.superview == nil }
        }
    }
    
    func removeAnimation(_ animation: AnimationView) {
        DispatchQueue.main.async {
            animation.stop()
            animation.removeFromSuperview()
        }
    }
}
