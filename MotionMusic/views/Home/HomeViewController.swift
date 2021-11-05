//
//  HomeViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import iCarousel

var DEBUG_MODE = false

class HomeViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    //MARK: OUTLETS
    @IBOutlet weak var InterfaceView: UIView!

    @IBOutlet weak var SeeAreasButton: UIButton!
    
    @IBOutlet weak var Carousel: UIView!
    
    //MARK: CAROUSEL CONFIGURATION
    
    let carousel: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    func setupCarousel(){
        carousel.frame = Carousel.frame
        carousel.dataSource = self
        carousel.delegate = self
        carousel.stopAtItemBoundary = true

        print("carousel criado")
        carousel.scrollToItem(at: (0), animated: true)
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return mockMusics.count
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        carousel.reloadData()
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 1.5 // 1.5 points spacing
        
//        case .visibleItems: return 11

            default: return value
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let view = setupCarouselItemView(item: mockMusics[index])
        return view
    }
    
    func setupCarouselItemView(item : MusicModel) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.backgroundColor = item.color
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        
        return view
    }
    
    
    //MARK: VARIABLES
    private var seeAreas: Bool = true {
        didSet {
            if self.seeAreas {
                self.SeeAreasButton.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                self.SeeAreasButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        }
    }
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Carousel.addSubview(carousel)
        setupCarousel()
        
        self.view.bringSubviewToFront(self.InterfaceView)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: AV CAPTURE SESSION
    func configSession() {
        
    }
    
    //MARK: UI BUTTONS
    @IBAction func onSwitchCamera(_ sender: Any) {
        
    }
    @IBAction func onTutorial(_ sender: Any) {
        
    }
    @IBAction func onSeeAreas(_ sender: Any) {
        seeAreas.toggle()
    }
    @IBAction func onTimer(_ sender: Any) {
        
    }
}
