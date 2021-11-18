//
//  MenuView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 15/11/21.
//
import UIKit

class MenuView : UIView {
    
    var music: MusicModel { get { mm.music } }
    var effect: EffectStyleModel { get { mm.effect } }
    
    @IBOutlet weak var MusicButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var RecordButton: RingView!
    
    var onButtonPressed: (() -> Void)?
    var onMusicPressed: (() -> Void)?
    var onEffectPressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func onUpdateMusic() {
        MusicButton.titleLabel?.text = music.name
        MusicButton.subtitleLabel?.text = music.authorName
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("MenuView", owner: self)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuView)

        menuView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        menuView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        onUpdateMusic()
        
        mm.didSetMusic[self.hashValue] = { self.onUpdateMusic() }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onRecord))
        RecordButton.addGestureRecognizer(tap)
    }
    
    @objc func onRecord(_ sender: Any) {
        self.onButtonPressed?()
    }
    
    @IBAction func onMusic(_ sender: Any) {
        self.onMusicPressed?()
    }
    
    @IBAction func onEffect(_ sender: Any) {
        self.onEffectPressed?()
    }
}
