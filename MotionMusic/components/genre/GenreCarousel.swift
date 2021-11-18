//
//  GenreCarousel.swift
//  MotionMusic
//
//  Created by Bruno Imai on 18/11/21.
//
import UIKit

class GenreCarousel: CustomCarouselView<MusicGenreModel> {
    
    override func setupCarouselItemView(item: MusicGenreModel, isMain: Bool) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        
        let genreView = isMain ? SelectedGenreView() : UnselectedGenreView()
        genreView.item = item
        
        view.addSubview(genreView)
        return view
    }
}
