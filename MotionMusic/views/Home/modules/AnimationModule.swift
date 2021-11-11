//
//  AnimationModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import Lottie

extension HomeViewController {
    func createAnimation(point: CGPoint, animation: String, size: CGFloat = 240) {
        DispatchQueue.main.async {
            let animationView = AnimationView(name: animation)
            let fixedPoint = self.percentToFramePoint(percent: point)
            animationView.frame = CGRect(x: fixedPoint.x - size / 2, y: fixedPoint.y - size / 2, width: size, height: size)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            
            self.AnimationsView.addSubview(animationView)
            self.animations.append(animationView)
            animationView.play { _ in
                UIView.animate(withDuration: 0.2) {
                    animationView.alpha = 0
                } completion: { _ in
                    self.removeAnimation(animationView)
                }
            }
        }
    }
    
    func removeAnimation(_ animation: AnimationView) {
        DispatchQueue.main.async {
            animation.removeFromSuperview()
            self.animations.removeAll { $0.superview == nil }
        }
    }
}
