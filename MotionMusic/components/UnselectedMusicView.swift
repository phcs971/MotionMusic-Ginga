//
//  MusicName.swift
//  MotionMusic
//
//  Created by Bruno Imai on 15/11/21.
//

import UIKit

class UnselectedMusicView: CarouselMusicView {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func updateView() {
        nameLabel.text = music.name
        authorLabel.text = music.authorName
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        Bundle.main.loadNibNamed("UnselectedMusicView", owner: self)
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
