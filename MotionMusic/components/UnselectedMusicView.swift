//
//  UnselectedMusicView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 09/11/21.
//

import UIKit

class UnselectedMusicView: CarouselMusicView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView(){
        nameLabel.text = music.name
        centerView.backgroundColor = music.color
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
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
