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
        nameLabel.textColor = UIColor(named: "AccentColor")
        authorLabel.textColor = UIColor(named: "AccentColor")
        circleMark.backgroundColor = UIColor(named: "AccentColor")
    }
    
    override func getFileName() -> String { "SelectedMusicView" }
}
