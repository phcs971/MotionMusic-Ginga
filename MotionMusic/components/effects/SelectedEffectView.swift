//
//  SelectedMusicView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 09/11/21.
//

import UIKit

class SelectedEffectView: BaseCarouselItem<EffectStyleModel> {
    
    @IBOutlet weak var ringView: RingView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView() {
        nameLabel.text = item.name
        ringView.color = item.colors[1].withAlphaComponent(0.65)
        centerView.addLinearGradient(colors: item.colors)
    }
    
    override func getFileName() -> String { "SelectedEffectView" }
}

extension UIView {
    func addLinearGradient( colors : [UIColor]){
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = colors.map { $0.cgColor }
        
        var locations = [Float]()
        let max: Float = Float(colors.count) - 1
        
        for i in(0 ..< colors.count) { locations.append(Float(i) / max) }
        
        gradient.locations = locations.map { NSNumber(value: $0) }

        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
}
