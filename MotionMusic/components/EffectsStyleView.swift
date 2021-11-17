//
//  EffectsStyleView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//
import UIKit
import iCarousel

class CarouselEffectView: UIView {
    var effect: StyleModel! { didSet { self.updateView() } }
    func updateView() { }
}

class EffectsStyleView: CarouselGenreView,iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var CarouselBackgroundView: UIView!
    
    
    
    let CarouselView: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    func setupCarousel(){
        self.CarouselBackgroundView.addSubview(self.CarouselView)
        self.CarouselView.frame = self.CarouselBackgroundView.frame
        self.CarouselView.center.x = self.frame.midX
        self.CarouselView.dataSource = self
        self.CarouselView.delegate = self
        self.CarouselView.stopAtItemBoundary = true
        
        print("Carousel Criado")
        //        self.CarouselView.scrollToItem(at: (3), animated: true)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return mockMusics.count
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.CarouselView.reloadData()
        self.genre = mockMusicsGenre[carousel.currentItemIndex]
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 1.1
        default: return value
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        setupCarouselItemView(item: mockMusics[index], isMain: index == self.CarouselView.currentItemIndex)
    }
    
    func setupCarouselItemView(item : MusicModel, isMain: Bool) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 104))
        var musicView: CarouselGenreView
        if isMain {
            musicView = SelectedEffectView()
            
        } else { musicView = UnselectedEffectView() }
        musicView.Q = item
        
        view.addSubview(musicView)
        return view
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
        Bundle.main.loadNibNamed("EffectsStyleView", owner: self)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
