//
//  UnselectedGenre.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit


class UnselectedGenreView: BaseCarouselItem<MusicGenreModel> {
//    @IBOutlet override var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView() {
        nameLabel.text = item.name
    }
    
    override func getFileName() -> String { "UnselectedGenreView" }
    
}
