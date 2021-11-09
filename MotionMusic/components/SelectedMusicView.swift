//
//  SelectedMusicView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 09/11/21.
//

import UIKit

class SelectedMusicView: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var ringView: RingView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var music : MusicModel! {
        didSet {
            self.updateView()
    }}
    
    private func updateView(){
        nameLabel.text = music.name
        nameLabel.backgroundColor = music.color
        ringView.color = music.color
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
        Bundle.main.loadNibNamed("SelectedMusicView", owner: self)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
