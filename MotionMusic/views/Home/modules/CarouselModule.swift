//
//  CarouselModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit

extension HomeViewController {
    func setBottomView() {
        self.CarouselBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        let (view, height) = getBottomView()
        self.BottomViewHeight.constant = height
        self.view.layoutIfNeeded()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.CarouselBackgroundView.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.CarouselBackgroundView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.CarouselBackgroundView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.CarouselBackgroundView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.CarouselBackgroundView.bottomAnchor).isActive = true
    }
    
    func getBottomView() -> (UIView, Double) {
        switch self.state {
        case .Normal:
            return (menuView, 80)
        case .Music:
            return (UIView(), 104)
        case .Effect:
            return (effectsCarousel, 104)
        case .Recording:
            return (UIView(), 104)
        case .none:
            return (UIView(), 104)
        }
    }
    
    func setupBottomViews() {
        menuView.onButtonPressed = { self.startStopRecording(self) }
        menuView.onMusicPressed = { self.state = .Music }
        menuView.onEffectPressed = { self.state = .Effect }
        
        let f = self.CarouselBackgroundView.frame
        
        effectsCarousel = EffectsStyleCarousel(frame: CGRect(x: 0, y: 0, width: f.width, height: 104))
    }
}
