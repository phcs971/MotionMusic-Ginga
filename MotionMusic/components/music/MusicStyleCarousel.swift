//
//  MusicStyleView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit
import iCarousel

class MusicStyleCarousel: CustomCarouselView<MusicModel> {
    override public var items: [MusicModel] { mm.musics }
    
    override func didChange(_ item: MusicModel) {
        mm.music = item
        if !SettingsService.instance.configuring { SettingsService.instance.saveMusic(item.id) } 
    }
    
    override func setupCarousel() {
        super.setupCarousel()
        mm.didSetGenre[self.hashValue] = {
            self.CarouselView.reloadData()
            let index = SettingsService.instance.configuring ? self.items.firstIndex { $0.id == SettingsService.instance.musicId } ?? 0 : 0
            self.CarouselView.scrollToItem(at: index, animated: false)
        }
    }
    
    override func setupCarouselItemView(item: MusicModel, isMain: Bool) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 42))
        
        let effectView = isMain ? SelectedMusicView() : UnselectedMusicView()
        effectView.item = item
        
        view.addSubview(effectView)
        return view
    }
    
    func updateForDefault() {
        let index = items.firstIndex { $0.id == SettingsService.instance.musicId }
        if index != nil { self.CarouselView.scrollToItem(at: index!, animated: false) }
    }
}
