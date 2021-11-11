//
//  CarouselModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import iCarousel

extension HomeViewController {
    func setupCarousel(){
        self.CarouselBackgroundView.addSubview(self.CarouselView)
        self.CarouselView.frame = self.CarouselBackgroundView.frame
        self.CarouselView.center.x = view.frame.midX
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
        self.music = mockMusics[carousel.currentItemIndex]
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
        var musicView: CarouselMusicView
        if isMain {
            musicView = SelectedMusicView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.startStopRecording(_:)))
            musicView.addGestureRecognizer(tap)
        } else { musicView = UnselectedMusicView() }
        musicView.music = item
        
        view.addSubview(musicView)
        return view
    }
}
