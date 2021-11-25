//
//  GenreCarousel.swift
//  MotionMusic
//
//  Created by Bruno Imai on 18/11/21.
//
import UIKit

class GenreCarousel: CustomCarouselView<MusicGenreModel> {
    override public var items: [MusicGenreModel] { mm.genres }
    
    override func didChange(_ item: MusicGenreModel) {
        mm.genre = item
        if !SettingsService.instance.configuring { SettingsService.instance.saveGenre(item.id) } 
    }

    
    override func setupCarouselItemView(item: MusicGenreModel, isMain: Bool) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        
        let genreView = isMain ? SelectedGenreView() : UnselectedGenreView()
        genreView.item = item
        
        view.addSubview(genreView)
        return view
    }
    
    func updateForDefault() {
        let index = items.firstIndex { $0.id == SettingsService.instance.genreId }
        if index != nil { self.CarouselView.scrollToItem(at: index!, animated: false) }
    }
}
