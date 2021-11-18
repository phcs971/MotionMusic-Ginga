//
//  MusicMenuView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 18/11/21.
//

import UIKit

class EffectMenuView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var effectCarousel: EffectsStyleCarousel!
    
    func setup() {
        let width = self.frame.width
        self.effectCarousel = EffectsStyleCarousel(frame: CGRect(x: 0, y: 0, width: width, height: 104))

        self.effectCarousel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(effectCarousel)
        
        self.effectCarousel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.effectCarousel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.effectCarousel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.effectCarousel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
}
