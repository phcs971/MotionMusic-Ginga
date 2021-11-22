//
//  CarouselModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit

extension HomeViewController {
    func setBottomView() {
        if topMenuIsOpen { openCloseTopMenu(self) }
        self.recordingView.stopPulsing()
        let height = getBottomViewHeight()
        self.BottomViewHeight.constant = height
        switch self.state {
        case .Normal:
            menuView.onUpdateEffect()
            menuView.onUpdateMusic()
            self.changeBottomTo(viewAtIndex: 0)
        case .Music:
            self.changeBottomTo(viewAtIndex: 1)
        case .Effect:
            self.changeBottomTo(viewAtIndex: 2)
        case .Recording:
            self.changeBottomTo(viewAtIndex: 3)
        default: break
        }
        self.view.layoutIfNeeded()
    }
    
    func changeBottomTo(viewAtIndex index: Int) {
        var views = [menuView!, musicMenuView!, effectMenuView!, recordingView!]
        self.show(views[index])
        views.remove(at: index)
        self.hide(views)
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
        recordingView.onButtonPressed = { self.startStopRecording(self)}
    }
}
