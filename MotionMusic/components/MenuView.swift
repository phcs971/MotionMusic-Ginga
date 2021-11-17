//
//  MenuView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 15/11/21.
//
import UIKit

class MenuView : UIView {
    
    var music: MusicModel!
    
    @IBOutlet weak var MusicButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var styleImage: UIImageView!
    @IBOutlet weak var menuView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        
        MusicButton.titleLabel?.text = music.name
        MusicButton.subtitleLabel?.text = music.authorName
        
        Bundle.main.loadNibNamed("MenuView", owner: self)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuView)
    }
}
