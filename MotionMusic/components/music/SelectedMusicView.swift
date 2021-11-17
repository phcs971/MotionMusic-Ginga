//
//  SelectedMusicView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit

class SelectedMusicView: BaseCarouselItem<MusicModel> {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func updateView() {
        nameLabel.text = item.name
        authorLabel.text = item.authorName
        nameLabel.textColor = item.color
        authorLabel.textColor = item.color
        
    }
    override func getFileName() -> String { "SelectedMusicView" }
}
