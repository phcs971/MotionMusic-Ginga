//
//  MusicStyleView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit
import iCarousel

class MusicStyleView: CarouselMusicView,iCarouselDataSource, iCarouselDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var musicGenreCarouselContainer: UIView!
    @IBOutlet weak var musicCarouselContainer: UIView!
    
    let musicCarouselView: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    let genreCarouselView: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    
    func setupMusicCarousel(){
        self.musicCarouselContainer.addSubview(self.musicCarouselView)
        self.musicCarouselView.frame = self.backgroundView.frame
        self.musicCarouselView.center.x = self.frame.midX
        self.musicCarouselView.dataSource = self
        self.musicCarouselView.delegate = self
        self.musicCarouselView.stopAtItemBoundary = true
        
        print("Carousel Musica Criado")
    }
    
    func setupGenreCarousel(){
        self.musicGenreCarouselContainer.addSubview(self.genreCarouselView)
        self.genreCarouselView.frame = self.backgroundView.frame
        self.genreCarouselView.center.x = self.frame.midX
        self.genreCarouselView.dataSource = self
        self.genreCarouselView.delegate = self
        self.genreCarouselView.stopAtItemBoundary = true
        
        print("Carousel Generos Criado")
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
        Bundle.main.loadNibNamed("MusicStyleView", owner: self)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        setupMusicCarousel()
        setupGenreCarousel()
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        if carousel == musicCarouselContainer {
            return mockMusics.count
        }
        return mockMusicsGenre.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        return view
    }
    
    func setupMusicItemView(item : MusicModel, isMain: Bool) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
        var musicView: CarouselMusicView
        if isMain {
            musicView = SelectedMusicView()
            
            //TROCAR A MUSICA
            
        } else { musicView = UnselectedMusicView() }
        musicView.music = item
        
        view.addSubview(musicView)
        return view
    }

    func setupMusicGenreItemView(item : MusicModel, isMain: Bool) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
        var musicView: CarouselMusicView
        if isMain {
            musicView = SelectedMusicView()
            
            //TROCAR A MUSICA
            
        } else { musicView = UnselectedMusicView() }
        musicView.music = item
        
        view.addSubview(musicView)
        return view
    }

}
