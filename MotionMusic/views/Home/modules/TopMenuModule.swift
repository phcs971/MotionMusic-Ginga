//
//  TopMenuModule.swift
//  MotionMusic
//
//  Created by Bruno Imai on 23/11/21.
//

import UIKit

extension HomeViewController {
    
    func setupTopMenu(){
        TopMenuBackground.layer.cornerRadius = TopMenuBackground.frame.height/2
        TopMenuBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    @IBAction func openCloseTopMenu(_ sender: Any) {
        
        if topMenuIsOpen {
            TopMenuButton.setImage(.init(systemName: "chevron.left"), for: .normal)
            
            let movementRange = (view.frame.maxX - TopMenuButton.frame.maxX) + self.TopMenuBackground.frame.minX
            
            UIView.animate(withDuration: 0.3, animations: {
                self.TopMenuBackground.center = CGPoint(x: movementRange, y: self.TopMenuBackground.center.y)
                self.topMenuIsOpen = false
            })
        } else {
            
            TopMenuButton.setImage(.init(systemName: "chevron.right"), for: .normal)
            
            let movementRange = TopMenuButton.frame.maxX + (self.TopMenuBackground.frame.maxX - view.frame.maxX)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.TopMenuBackground.center = CGPoint(x: movementRange, y: self.TopMenuBackground.center.y)
                
                self.topMenuIsOpen = true
            })
        }
    }
    
    
    
    
}
