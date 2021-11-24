//
//  TopMenuModule.swift
//  MotionMusic
//
//  Created by Bruno Imai on 23/11/21.
//

import UIKit

extension HomeViewController {
    
    func setupTopMenu() {
        TopMenuBackground.layer.cornerRadius = TopMenuBackground.frame.height/2
        TopMenuBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    @IBAction func openCloseTopMenu(_ sender: Any) {
        
        let range = TopMenuBackground.frame.width - TopMenuButton.frame.width
        
        if topMenuIsOpen {
            TopMenuButton.setImage(.init(systemName: "chevron.left"), for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.TopMenuBackground.center += CGPoint(x: range , y: 0)
                self.topMenuIsOpen = false
            })
        } else {
            
            TopMenuButton.setImage(.init(systemName: "chevron.right"), for: .normal)

            UIView.animate(withDuration: 0.3, animations: {
                self.TopMenuBackground.center -= CGPoint(x: range , y: 0)
                self.topMenuIsOpen = true
            })
        }
    }
    
    func loadSettings() {
        microphone = SettingsService.instance.loadMicrophone()
        seeAreas = SettingsService.instance.loadAreas()
        timerNumber = SettingsService.instance.loadTimer()
        if frontCamera != SettingsService.instance.loadCamera() {
            self.onSwitchCamera(self)
        }
        
        configTimer()
    }
    
}
