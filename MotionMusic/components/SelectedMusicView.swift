//
//  SelectedMusicView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit

class SelectedMusicView: CarouselMusicView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var circleMark: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    
    override func updateView() {
        nameLabel.text = music.name
        authorLabel.text = music.authorName
        circleMark.backgroundColor = music.color
        
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
        Bundle.main.loadNibNamed("SelectedMusicView", owner: self)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
