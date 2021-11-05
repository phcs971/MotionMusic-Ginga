//
//  HomeViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit

var DEBUG_MODE = false

class HomeViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var InterfaceView: UIView!

    @IBOutlet weak var SeeAreasButton: UIButton!
    
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
