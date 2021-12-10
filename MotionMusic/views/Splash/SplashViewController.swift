//
//  ViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

//    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var animation: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.animate()
    }
    
    func animate() {
        
        self.animation.contentMode = .scaleAspectFit
        self.animation.loopMode = .playOnce
        self.animation.animationSpeed = 1.5
        self.animation.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
            if SettingsService.instance.firstOpen {
                self.performSegue(withIdentifier: "OnboardingSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "StartSegue", sender: self)
            }
        }
    }
}

