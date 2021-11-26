//
//  OnboardingViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 25/11/21.
//

import UIKit

struct OnboardingPage: Identifiable {
    var id = UUID().uuidString
    
    var index: Int
    
    var title: String
    var description: String
    
    var titleImageOffset: CGFloat = 0
    
    var titleImage: String { "effect\(index+1)" }
    var image: String { "onboarding\(index+1)" }
    
    var titleImageAspectRatio: CGFloat
    var imageAspectRatio: CGFloat
}

let onboardingPages = [
    OnboardingPage(
        index: 0,
        title: "seu ritmo faz a batida",
        description: "Bem vindo a Ginga! Sua ferramenta que traz vida para sua dança e cores para as suas músicas simplesmente com o seu movimento!",
        titleImageAspectRatio: 314/19,
        imageAspectRatio: 229/286
    ),
    OnboardingPage(
        index: 1,
        title: "música em cores",
        description: "Interaja com os círculos para ver a mágica acontecer! Aproxime seu corpo dos círculos e bata palmas para tocar cada nota da sua música favorita!",
        titleImageOffset: -40,
        titleImageAspectRatio: 267/73,
        imageAspectRatio: 131/155
    ),
    OnboardingPage(
        index: 2,
        title: "tudo no seu estilo",
        description: "Do som até a cor das animações, é você quem escolhe! Você encontra essas opções no menu inferior. ",
        titleImageAspectRatio: 267/26,
        imageAspectRatio: 93/163
    ),
    OnboardingPage(
        index: 3,
        title: "totalmente personalizável",
        description: "No menu superior você pode ocultar os círculos, colocar timer, ligar seu microfone para cantar junto e inverter a câmera.",
        titleImageAspectRatio: 89/9,
        imageAspectRatio: 229/286
    ),
    OnboardingPage(
        index: 4,
        title: "é hora de dar o seu show",
        description: "Depois que voce praticou, é hora de gravar! Os círculos de referência somem e só as animações e sons ficam!",
        titleImageAspectRatio: 89/13,
        imageAspectRatio: 189/299
    ),
    OnboardingPage(
        index: 5,
        title: "agora é só compartilhar",
        description: "Mostre para o mundo o que voce fez! Salve e compartilhe sua performance! Bora começar?",
        titleImageAspectRatio: 89/10,
        imageAspectRatio: 69/109
    )
]

class OnboardingViewController: UIViewController {

    @IBOutlet weak var ContentPage: UIView!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 12
        
        nextButton.setTitle("Próximo", for: .normal)
        setup()
    }
    
    var currentPage = 0 {
        didSet {
            print(currentPage)
//            UIView.animate(withDuration: 0.5) {
            self.skipButton.alpha = self.currentPage == onboardingPages.count ? 0 : 1
//            }

            if currentPage == onboardingPages.count {
                nextButton.setTitle("Começar a dançar!", for: .normal)
            } else {
                nextButton.setTitle("Próximo", for: .normal)
            }
        }
    }
    
    var pvController: UIPageViewController?
    
    @IBAction func next() {
        if currentPage == onboardingPages.count {
            self.performSegue(withIdentifier: "home", sender: self)
        } else {
            if let pageViewController = self.pvController {
            
            guard let currentViewController = pageViewController.viewControllers?.first else { return print("Failed to get current view controller") }

                guard let nextViewController = self.pageViewController(pageViewController, viewControllerAfter: currentViewController) else { return }

                pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                currentPage += 1
            }
        }
    }
    
    func setup() {
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: OnboardingSlideViewController.self)) as? OnboardingSlideViewController else { return }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        ContentPage.addSubview(pageViewController.view)
        
        let views: [String: UIView] = ["pageView": pageViewController.view]
        
        ContentPage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pageView]-0-|",
            options: .init(rawValue: 0),
            metrics: nil,
            views: views
        ))
        ContentPage.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[pageView]-0-|",
            options: .init(rawValue: 0),
            metrics: nil,
            views: views
        ))
        
        guard let startingViewController = detailViewController(at: currentPage) else { return }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        
        pvController = pageViewController
    }
    
    func detailViewController(at index: Int) -> OnboardingPageViewController? {
        if index >= onboardingPages.count || onboardingPages.count == 0 {
            return nil
        }
        
        guard let page = storyboard?.instantiateViewController(withIdentifier: String(describing: OnboardingPageViewController.self)) as? OnboardingPageViewController else { return nil }
        
        page.page = onboardingPages[index]
        return page
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let page = viewController as? OnboardingPageViewController {
            var i = page.page!.index
            if i != 0 {
                i -= 1
                currentPage = i
                return detailViewController(at: currentPage)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let page = viewController as? OnboardingPageViewController {
            var i = page.page!.index
            if i != onboardingPages.count {
                i += 1
                currentPage = i
                return detailViewController(at: currentPage)
            }
        }
        return nil
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentPage
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        onboardingPages.count
    }
}
