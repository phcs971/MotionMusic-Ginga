//
//  OnboardingPageViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 26/11/21.
//

import UIKit

class OnboardingPageViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var TitleImageOffset: NSLayoutConstraint!
    @IBOutlet weak var TitleImageAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var ImageAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    var page: OnboardingPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        if let page = page {
            TitleLabel.text = page.title
            
            let descriptor = UIFont.systemFont(ofSize: 44, weight: .semibold).fontDescriptor.withDesign(.serif)!
            TitleLabel.font = .init(descriptor: descriptor, size: 0)
            TitleImage.image = UIImage(named: page.titleImage)
            TitleImageOffset.constant = page.titleImageOffset
            
            let titleAR = TitleImageAspectRatio.constraintWithMultiplier(page.titleImageAspectRatio)
            TitleImage.removeConstraint(TitleImageAspectRatio)
            TitleImage.addConstraint(titleAR)
            TitleImageAspectRatio = titleAR
            
            Image.image = UIImage(named: page.image)
            let imageAR = ImageAspectRatio.constraintWithMultiplier(page.imageAspectRatio)
            Image.removeConstraint(ImageAspectRatio)
            Image.addConstraint(imageAR)
            ImageAspectRatio = imageAR
            
            DescriptionLabel.text = page.description
            
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
        }
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
