//
//  RecordingView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 0.752/11/21.
//

import UIKit

class RecordingView: UIView {
    
    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var RecordButton: RingView!
    @IBOutlet weak var RecordingIndicator: UIView!
    
    var pulsing = false
    
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
    
    func startPulsing() {
        self.pulsing = true
        self.pulse()
    }
    
    func stopPulsing() {
        self.pulsing = false
    }
    
    func pulse() {
        UIView.animate(withDuration: 0.75, delay: 0) {
            self.RecordingIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.75, delay: 0) {
                self.RecordingIndicator.transform = .identity
            } completion: { _ in
                if self.pulsing { self.pulse() }
            }

        }
    }
    
    @objc func onRecord(_ sender: Any) {
        self.onButtonPressed?()
    }

}
