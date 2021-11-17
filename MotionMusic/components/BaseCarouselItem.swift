//
//  BaseCarouselItem.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 17/11/21.
//

import UIKit

class BaseCarouselItem<Element>: UIView {
    @IBOutlet weak var backgroundView: UIView!
    var item: Element! { didSet { self.updateView() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setup()
    }
    
    func updateView() {
        fatalError("Must Override")
    }
    
    func getFileName() -> String {
        fatalError("Must Override")
    }
    
    func setup() {
        Bundle.main.loadNibNamed(getFileName(), owner: self)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
