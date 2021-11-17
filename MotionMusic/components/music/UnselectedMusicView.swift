//
//  MusicName.swift
//  MotionMusic
//
//  Created by Bruno Imai on 15/11/21.
//

import UIKit

class UnselectedMusicView: BaseCarouselItem<MusicModel> {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func updateView() {
        nameLabel.text = item.name
        authorLabel.text = item.authorName
        
    }
    override func getFileName() -> String { "UnselectedMusicView" }
}
