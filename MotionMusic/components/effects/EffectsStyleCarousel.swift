//
//  EffectsStyleView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//
import UIKit
import iCarousel


class EffectsStyleCarousel: CustomCarouselView<EffectStyleModel> {
    override public var items: [EffectStyleModel] { mm.effects }
    
    override func didChange(_ item: EffectStyleModel) {
        mm.effect = item
        if !SettingsService.instance.configuring { SettingsService.instance.saveEffect(item.id!) } 
    }
    
    override func setupCarousel() {
        super.setupCarousel()
        mm.didSetEffects[self.hashValue] = {
            self.CarouselView.reloadData()
            self.updateForDefault()
        }
    }
    
    override func setupCarouselItemView(item: EffectStyleModel, isMain: Bool) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 104))
        let effectView = isMain ? SelectedEffectView() : UnselectedEffectView()
        effectView.item = item
        
        view.addSubview(effectView)
        return view
    }
    
    func updateForDefault() {
        let index = items.firstIndex { $0.id == SettingsService.instance.effectId } ?? items.firstIndex{ $0.showAnimation }
        if index != nil { self.CarouselView.scrollToItem(at: index!, animated: false) }
    }
}
