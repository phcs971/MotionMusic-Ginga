//
//  RecordingView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 22/11/21.
//

import UIKit

class RecordingView: UIView {
    
    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var RecordButton: RingView!
    
    var onButtonPressed: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("RecordingView", owner: self)
        self.BackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.BackgroundView)

        self.BackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.BackgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.BackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.BackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onRecord))
        RecordButton.addGestureRecognizer(tap)
    }
    
    @objc func onRecord(_ sender: Any) {
        self.onButtonPressed?()
    }

}
