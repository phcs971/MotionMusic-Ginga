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
        lazy var gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.type = .axial
            gradient.colors = [
                colors[0].cgColor,
                colors[1].cgColor,
                colors[2].cgColor,
                ]
            gradient.locations = [0, 1]
                return gradient
        }()

        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
}
