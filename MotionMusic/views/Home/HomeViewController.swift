//
//  HomeViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit

import AVFoundation
import Vision
import ReplayKit

import iCarousel

import Lottie



//TODO: Melhorar precisão da detecçao dos botoes

enum BottomState: Int {
    case Normal = 0
    case Music = 1
    case Effect = 2
    case Recording = 3
}

class HomeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var InterfaceView: UIView!
    @IBOutlet weak var SoundButtonsView: UIView!
    @IBOutlet weak var AnimationsView: UIView!
    
    @IBOutlet weak var TopMenuBackground: UIView!
    @IBOutlet weak var TopMenuButton: UIButton!
    @IBOutlet weak var TimerButton: UIButton!
    @IBOutlet weak var SeeAreasButton: UIButton!
    @IBOutlet weak var MicButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    
    @IBOutlet weak var FpsLabel: UILabel!
    
    @IBOutlet weak var PreviewView: UIView!
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var CarouselBackgroundView: UIView!
    
    @IBOutlet weak var ReturnButton: UIButton!
    
    @IBOutlet weak var BottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var HomeLoadingView: LoaderView!
    
    @IBOutlet weak var TimerView: UIView!
    @IBOutlet weak var TimerNumberLabel: UILabel!
    
    var uiButtons: [UIButton] { [TimerButton, SeeAreasButton, MicButton, CameraButton] }
    
    let defaults = UserDefaults.standard
    
    //MARK: VARIABLES
    var lastFrame = Date()
    
    var seeAreas: Bool = true {
        didSet {
            DispatchQueue.main.async {
                if self.seeAreas {
                    self.SeeAreasButton.setImage(UIImage(systemName: "eye"), for: .normal)
                    self.createSoundButtons()
                    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) { self.SoundButtonsView.alpha = 1 }
                    
                } else {
                    self.SeeAreasButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) { self.SoundButtonsView.alpha = 0 }
                }
            }
        }
    }
    
    var rootLayer: CALayer!
    var detectionLayer: CALayer!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkDebugMode()
        
        if !IS_SIMULATOR{
            self.PreviewView.backgroundColor = .clear
            self.configSession()
            self.setupLayers()
        }
        
        self.view.bringSubviewToFront(self.InterfaceView)
        mm.didSetMusic[self.hashValue] = { self.onDidSetMusic() }
        mm.willSetMusic[self.hashValue] = { self.onWillSetMusic() }
        mm.didSetEffect[self.hashValue] = { self.onDidSetEffect() }
        
        let animTap = UITapGestureRecognizer(target: self, action: #selector(self.onReturnMenu))
        self.AnimationsView.addGestureRecognizer(animTap)
        
        self.setupBottomViews()
        
        self.setupTopMenu()
        
        if !IS_SIMULATOR { self.setupVision() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !IS_SIMULATOR && !self.session.isRunning { self.start() }
        self.music = genre.musics.first!
        yFactor = self.BottomView.frame.height / self.PreviewView.frame.height
        self.state = .Normal
        
        loadSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "review" {
            if let destination = segue.destination as? ReviewViewController, let url = self.outputUrl {
                destination.url = url
            }
        }
    }
    
    //MARK: CAROUSEL
    
    var state: BottomState! {
        didSet {
            DispatchQueue.main.async {
                self.setBottomView()
                self.ReturnButton.alpha = [BottomState.Normal, BottomState.Recording].contains(self.state) ? 0 : 1
            }
        }
    }
    
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var effectMenuView: EffectMenuView!
    @IBOutlet weak var musicMenuView: MusicMenuView!
    @IBOutlet weak var recordingView: RecordingView!
    
    //MARK: CAPTURE SESSION
    
    let session = AVCaptureSession()
    
    var output = AVCaptureVideoDataOutput()
    
    let outputQueue = DispatchQueue(label: "pr.puc.ada.MotionMusic.queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    var bufferSize: CGSize = .zero { didSet { DispatchQueue.main.async { self.calculateOverflow() } } }
    
    var horizontalOverflow = 0.0
    
    var verticalOverflow = 0.0
    
    //MARK: VISION
    
    var points = [PointGroupModel<AnyHashable>]()
    
    var requests = [VNRequest]()
    
    //MARK: SOUNDS
    
    var isClapping = false
    
    //MARK: RECORDING
    
    var loadingResult = false {
        didSet {
            DispatchQueue.main.async {
                if self.loadingResult {
                    self.view.bringSubviewToFront(self.HomeLoadingView)
                    self.HomeLoadingView.isHidden = false
                    UIView.animate(withDuration: 0.5) {
                        self.HomeLoadingView.alpha = 1
                    } completion: { _ in
                        self.HomeLoadingView.Animation.play()
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.HomeLoadingView.alpha = 0
                    } completion: { _ in
                        self.HomeLoadingView.Animation.stop()
                    }
                    self.HomeLoadingView.isHidden = true
                    self.view.sendSubviewToBack(self.HomeLoadingView)
                }
            }
        }
    }
    
    let recorder = RPScreenRecorder.shared()
    
    var isRecording = false {
        didSet {
            updateRecordingUI()
            self.state = isRecording ? .Recording : .Normal
        }
    }
    
    var yFactor: CGFloat = 0.0
    
    var prevSeeAreas = true
    
    var outputUrl: URL?
    
    
    
    //MARK: MOTION MUSIC
    
    var effect: EffectStyleModel {
        get {
            mm.effect
        } set {
            mm.effect = newValue
        }
    }
    
    var genre: MusicGenreModel  {
        get {
            mm.genre
        } set {
            mm.genre = newValue
        }
    }
    
    var music: MusicModel  {
        get {
            mm.music
        } set {
            mm.music = newValue
        }
    }
    
    func onWillSetMusic() {
        for controller in self.soundControllers {
            if controller.player?.isPlaying ?? false { controller.player?.stop() }
            self.removeAnimation(controller)
        }
    }
    
    func onDidSetMusic() {
        updateSoundControllers()
//        self.seeAreas = true
    }
    
    func onDidSetEffect() {
        updateAllAnimations()
    }
    
    var soundControllers = [SoundButtonController]()
    
    //MARK: ANIMATIONS
    
    var animations = [AnimationView]()
    
    //MARK: UI BUTTONS
    
    var frontCamera = true
    
    var microphone = false {
        didSet {
            DispatchQueue.main.async {
                self.MicButton.setImage(UIImage(systemName: self.microphone ? "mic.fill" : "mic.slash.fill"), for: .normal)
            }
        }
    }
    
    //MARK: TOP MENU
    
    var timerNumber = 0
    
    var topMenuIsOpen = false
    
    func configTimer () {
        
        switch timerNumber {
            
        case 3:
            self.TimerButton.setImage(UIImage(systemName: "3.circle"), for: .normal)
           
        case 10:
            timerNumber = 0
            self.TimerButton.setImage(UIImage(systemName: "10.circle"), for: .normal)
            
        default:
            self.TimerButton.setImage(UIImage(systemName: "deskclock"), for: .normal)
           
        }
    }
}

