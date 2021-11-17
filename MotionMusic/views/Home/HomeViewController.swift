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

class HomeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, iCarouselDataSource, iCarouselDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var InterfaceView: UIView!
    @IBOutlet weak var SoundButtonsView: UIView!
    @IBOutlet weak var AnimationsView: UIView!
    
    @IBOutlet weak var TimerButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var SeeAreasButton: UIButton!
    @IBOutlet weak var SeeAreasLabel: UILabel!
    @IBOutlet weak var TutorialButton: UIButton!
    @IBOutlet weak var TutorialLabel: UILabel!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var CameraLabel: UILabel!
    
    @IBOutlet weak var FpsLabel: UILabel!
    
    @IBOutlet weak var PreviewView: UIView!
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var CarouselBackgroundView: UIView!
    
    var uiButtons: [UIButton] { [TimerButton, SeeAreasButton, TutorialButton, CameraButton] }
    var uiLabels: [UILabel] { [TimerLabel, SeeAreasLabel, TutorialLabel, CameraLabel] }
    
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
        
        self.setupCarousel()
        
        self.view.bringSubviewToFront(self.InterfaceView)
        
        if !IS_SIMULATOR {
            self.setupVision()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { self.CarouselView.reloadData() }
    
    override func viewDidAppear(_ animated: Bool) {
        if !IS_SIMULATOR && !self.session.isRunning { self.start() }
        self.music = mockMusics.first!
        yFactor = self.BottomView.frame.height / self.PreviewView.frame.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "review" {
            if let destination = segue.destination as? ReviewViewController, let url = self.outputUrl {
                destination.url = url
            }
        }
    }
    
    //MARK: CAROUSEL
        
    let CarouselView: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    
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
    
    var isRecording = false { didSet { updateRecordingUI() } }
    
    var yFactor: CGFloat = 0.0
    
    var prevSeeAreas = true
    
    var outputUrl: URL?

    //MARK: MOTION MUSIC
    
    var music: MusicModel = mockMusics.first! { didSet { updateSoundControllers(); self.seeAreas = true } }
    
    var soundControllers = [SoundButtonController]()

    //MARK: ANIMATIONS
    
    var animations = [AnimationView]()
    
    //MARK: UI BUTTONS
    
    var frontCamera = true
}
