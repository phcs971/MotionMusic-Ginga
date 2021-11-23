//
//  ViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var LogoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseInOut) {
            self.LogoImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).rotated(by: .pi / 6)
        } completion: { _ in
            UIView.animate(withDuration: 0.05, delay: 0.2, options: .curveEaseIn) {
                self.LogoImage.alpha = 0
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
                self.LogoImage.transform = CGAffineTransform(scaleX: 50, y: 50)
            } completion: { _ in
                self.performSegue(withIdentifier: "StartSegue", sender: self)
            }
        }

    }


}

