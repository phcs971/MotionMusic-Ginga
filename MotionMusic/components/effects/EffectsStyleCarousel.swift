//
//  EffectsStyleView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//
import UIKit
import iCarousel


class EffectsStyleCarousel: CustomCarouselView<EffectStyleModel> {
    
    override func setupCarouselItemView(item: EffectStyleModel, isMain: Bool) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 104))
        
        let effectView = isMain ? SelectedEffectView() : UnselectedEffectView()
        effectView.item = item
        
        view.addSubview(effectView)
        return view
    }
}
