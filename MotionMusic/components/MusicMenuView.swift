//
//  MusicMenuView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 18/11/21.
//

import UIKit

class MusicMenuView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var musicCarousel: MusicStyleCarousel!
    var genreCarousel: GenreCarousel!
    
    func setup() {
        let width = self.frame.width
        musicCarousel = MusicStyleCarousel(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        genreCarousel = GenreCarousel(frame: CGRect(x: 0, y: 0, width: width, height: 72))

        self.musicCarousel.translatesAutoresizingMaskIntoConstraints = false
        self.genreCarousel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(genreCarousel)
        self.addSubview(musicCarousel)
        
        self.musicCarousel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.musicCarousel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.musicCarousel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.musicCarousel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        self.genreCarousel.heightAnchor.constraint(equalToConstant: 72).isActive = true
        self.genreCarousel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.genreCarousel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.genreCarousel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
//        self.genreCarousel.bottomAnchor.constraint(equalTo: self.musicCarousel.topAnchor).isActive = true
    }
}
