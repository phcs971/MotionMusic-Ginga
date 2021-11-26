//
//  SelectedGenre.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit


class SelectedGenreView: BaseCarouselItem<MusicGenreModel> {
    
//    @IBOutlet override var backgroundView: UIView!
    @IBOutlet weak var ringView: RingView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView() {
        nameLabel.text = item.name
        ringView.color = UIColor(named: "CPink")!.withAlphaComponent(0.8)
        centerView.backgroundColor = UIColor(named: "CPink")!
    }
    
    override func getFileName() -> String { "SelectedGenreView" }
}
