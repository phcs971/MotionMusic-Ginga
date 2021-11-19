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
        let title = NSMutableAttributedString(string: music.name, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
        ])
        MusicButton.setAttributedTitle(title, for: .normal)
        MusicButton.configuration?.subtitle = music.authorName
        MusicButton.updateConfiguration()
    }
    
    func onUpdateEffect() {
        let title = NSMutableAttributedString(string: effect.name, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
        ])
        styleButton.setAttributedTitle(title, for: .normal)
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
        onUpdateEffect()
        
        mm.didSetMusic[self.hashValue] = { self.onUpdateMusic() }
        mm.didSetEffect[self.hashValue] = { self.onUpdateEffect() }
        
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
