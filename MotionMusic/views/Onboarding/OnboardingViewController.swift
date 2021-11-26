//
//  OnboardingViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 25/11/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var bullets: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let descriptor = UIFont.systemFont(ofSize: 44, weight: .semibold).fontDescriptor.withDesign(.serif)!
        titleLabel.font = .init(descriptor: descriptor, size: 0)
        
        for bullet in bullets.subviews {
            bullet.clipsToBounds = true
            bullet.layer.cornerRadius = 5
        }
        
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 12
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
