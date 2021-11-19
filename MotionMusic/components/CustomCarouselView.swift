//
//  CustomCarouselView.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 17/11/21.
//

import UIKit

import iCarousel

class CustomCarouselView<Element>: UIView, iCarouselDataSource, iCarouselDelegate {
    
    public var items: [Element] { [] }
    
    var didChange: ((Element) -> Void)?
    
    let CarouselView: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCarousel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCarousel()
    }
    
    override func didMoveToWindow() {
        self.CarouselView.reloadData()
    }
    
    func setupCarousel() {
        self.CarouselView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.CarouselView)
        
        self.CarouselView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.CarouselView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.CarouselView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.CarouselView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.CarouselView.frame = self.frame
        self.CarouselView.center.x = self.frame.midX
        self.CarouselView.dataSource = self
        self.CarouselView.delegate = self
        self.CarouselView.stopAtItemBoundary = true
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.CarouselView.reloadData()
        self.didChange?(items[carousel.currentItemIndex])
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 1.1
        default: return value
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int { items.count }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        return setupCarouselItemView(item: items[index], isMain: index == self.CarouselView.currentItemIndex)
    }
    
    
    func setupCarouselItemView(item : Element, isMain: Bool) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 104))
        return view
    }
}
