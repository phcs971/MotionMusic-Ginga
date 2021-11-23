//
//  LoaderView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 23/11/21.
//

import UIKit
import Lottie

class LoaderView: UIView {
    
    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var Animation: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("LoaderView", owner: self)
        self.BackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.BackgroundView)

        self.BackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.BackgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.BackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.BackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(empty))
        self.BackgroundView.addGestureRecognizer(tap)
        
        self.Animation.contentMode = .scaleAspectFit
        self.Animation.loopMode = .autoReverse
    }
    
    @objc func empty(_ sender: Any) { }
}
