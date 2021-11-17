//
//  SelectedGenre.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit

class CarouselGenreView: UIView {
    var genre: MusicGenreModel! { didSet { self.updateView() } }
    func updateView() { }
}


class SelectedGenreView: CarouselGenreView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var ringView: RingView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateView() {
        nameLabel.text = genre.name
        nameLabel.backgroundColor = genre.color
        ringView.color = genre.color.withAlphaComponent(0.65)
        centerView.backgroundColor = genre.color
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
        Bundle.main.loadNibNamed("SelectedGenreView", owner: self)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
