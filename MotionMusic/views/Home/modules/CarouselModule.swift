//
//  CarouselModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit

extension HomeViewController {
    func setBottomView() {
//        self.CarouselBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        let height = getBottomViewHeight()
        self.BottomViewHeight.constant = height
        switch self.state {
        case .Normal:
            self.show(menuView)
            self.hide([musicMenuView, effectMenuView])
        case .Music:
            self.show(musicMenuView)
            self.hide([menuView, effectMenuView])
        case .Effect:
            self.show(effectMenuView)
            self.hide([menuView, musicMenuView])
        default: break
        }
        self.view.layoutIfNeeded()
//        view.translatesAutoresizingMaskIntoConstraints = false
        
//        self.CarouselBackgroundView.addSubview(view)
        
//        view.leadingAnchor.constraint(equalTo: self.CarouselBackgroundView.leadingAnchor).isActive = true
//        view.topAnchor.constraint(equalTo: self.CarouselBackgroundView.topAnchor).isActive = true
//        view.trailingAnchor.constraint(equalTo: self.CarouselBackgroundView.trailingAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: self.CarouselBackgroundView.bottomAnchor).isActive = true
    }
    
    func show(_ view: UIView) {
        view.alpha = 1
        view.isHidden = false
        self.CarouselBackgroundView.bringSubviewToFront(view)
    }
    
    func hide(_ views: [UIView]) {
        for view in views {
            view.alpha = 0
            view.isHidden = true
        }
    }
    
    func getBottomViewHeight() -> Double {
        switch self.state {
        case .Normal:
            return 80
        case .Music:
            return 128
        case .Effect:
            return 104
        case .Recording:
            return 80
        case .none:
            return 80
        }
    }
    
    func setupBottomViews() {
        menuView.onButtonPressed = { self.startStopRecording(self) }
        menuView.onMusicPressed = { self.state = .Music }
        menuView.onEffectPressed = { self.state = .Effect }
    }
}
