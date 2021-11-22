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

import AudioKit
import SoundpipeAudioKit

import iCarousel

import Lottie

let DEBUG_MODE = false
#if targetEnvironment(simulator)
let IS_SIMULATOR = true
#else
let IS_SIMULATOR = false
#endif

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
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var SeeAreasButton: UIButton!
    @IBOutlet weak var SeeAreasLabel: UILabel!
    @IBOutlet weak var MicButton: UIButton!
    @IBOutlet weak var MicLabel: UILabel!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var CameraLabel: UILabel!
    
    @IBOutlet weak var FpsLabel: UILabel!
    
    @IBOutlet weak var PreviewView: UIView!
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var CarouselBackgroundView: UIView!
    
    @IBOutlet weak var ReturnButton: UIButton!
    
    @IBOutlet weak var BottomViewHeight: NSLayoutConstraint!
    
    var uiButtons: [UIButton] { [TimerButton, SeeAreasButton, MicButton, CameraButton] }
    var uiLabels: [UILabel] { [TimerLabel, SeeAreasLabel, MicLabel, CameraLabel] }
    
    //MARK: VARIABLES
    var lastFrame = Date()
    
    var seeAreas: Bool = true {
        didSet {
            DispatchQueue.main.async {
                if self.seeAreas {
                    self.SeeAreasButton.setImage(UIImage(systemName: "eye"), for: .normal)
                    self.createSoundButtons()
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { self.SoundButtonsView.alpha = 1 }

                } else {
                    self.SeeAreasButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { self.SoundButtonsView.alpha = 0 }
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
        
        self.startAudio()
        
        if !IS_SIMULATOR{
            self.PreviewView.backgroundColor = .clear
            self.configSession()
            self.setupLayers()
        }
        
        self.view.bringSubviewToFront(self.InterfaceView)
        mm.didSetMusic[self.hashValue] = { self.onDidSetMusic() }
        
        self.setupBottomViews()
        
        self.setupTopMenu()
        
        if !IS_SIMULATOR { self.setupVision() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !IS_SIMULATOR && !self.session.isRunning { self.start() }
        self.music = genre.musics.first!
        yFactor = self.BottomView.frame.height / self.PreviewView.frame.height
        self.state = .Normal
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
    
    let engine = AudioEngine()
    
    let sampler = AppleSampler()
    
    var isClapping = false
    
    //MARK: RECORDING
    
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
    
    func onDidSetMusic() {
        updateSoundControllers()
        self.seeAreas = true
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
    
    //MARK: TOP MENU ANIMATIONS
    
    var topMenuIsOpen = false
    
    func setupTopMenu(){
        TopMenuBackground.layer.cornerRadius = TopMenuBackground.frame.height/2
        TopMenuBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    @IBAction func openCloseTopMenu(_ sender: Any) {
        
        if topMenuIsOpen {
            TopMenuButton.setImage(.init(systemName: "chevron.left"), for: .normal)
            
            let movementRange = (view.frame.maxX - TopMenuButton.frame.maxX) + self.TopMenuBackground.frame.minX
            
            UIView.animate(withDuration: 0.3, animations: {
                self.TopMenuBackground.center = CGPoint(x: movementRange, y: self.TopMenuBackground.center.y)
                self.topMenuIsOpen = false
            })
        } else {
            
            TopMenuButton.setImage(.init(systemName: "chevron.right"), for: .normal)
            
            let movementRange = TopMenuButton.frame.maxX + (self.TopMenuBackground.frame.maxX - view.frame.maxX)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.TopMenuBackground.center = CGPoint(x: movementRange, y: self.TopMenuBackground.center.y)
                
                self.topMenuIsOpen = true
            })
        }
    }
    
}

