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
    @IBOutlet weak var circleMark: UIView!
    
    override func updateView() {
        nameLabel.text = item.name
        authorLabel.text = item.authorName
        nameLabel.textColor = mm.genre.color
        authorLabel.textColor = mm.genre.color
        circleMark.backgroundColor = mm.genre.color
    }
    
    override func getFileName() -> String { "SelectedMusicView" }
}
