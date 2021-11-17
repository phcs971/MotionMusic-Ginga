//
//  SelectedGenre.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit


class SelectedGenreView: BaseCarouselItem<MusicGenreModel> {
    
    @IBOutlet weak var ringView: RingView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView() {
        nameLabel.text = item.name
        nameLabel.backgroundColor = item.color
        ringView.color = item.color.withAlphaComponent(0.65)
        centerView.backgroundColor = item.color
    }
    
    override func getFileName() -> String { "SelectedGenreView" }
}
