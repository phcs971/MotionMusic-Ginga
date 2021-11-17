//
//  UnselectedMusicView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 09/11/21.
//

import UIKit

class UnselectedEffectView: BaseCarouselItem<EffectStyleModel> {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView(){
        nameLabel.text = item.name
        centerView.backgroundColor = item.color
    }
    
    override func getFileName() -> String { "UnselectedEffectView" }
}
