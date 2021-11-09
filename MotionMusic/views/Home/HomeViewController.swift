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
import Photos

import AudioKit
import SoundpipeAudioKit

import iCarousel

let DEBUG_MODE = true
#if targetEnvironment(simulator)
let IS_SIMULATOR = true
#else
let IS_SIMULATOR = false
#endif

class HomeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, iCarouselDataSource, iCarouselDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var InterfaceView: UIView!
    @IBOutlet weak var SoundButtonsView: UIView!
    
    @IBOutlet weak var TimerButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var SeeAreasButton: UIButton!
    @IBOutlet weak var SeeAreasLabel: UILabel!
    @IBOutlet weak var TutorialButton: UIButton!
    @IBOutlet weak var TutorialLabel: UILabel!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var CameraLabel: UILabel!
    
    @IBOutlet weak var FpsLabel: UILabel!
    
    @IBOutlet weak private var PreviewView: UIView!
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var CarouselBackgroundView: UIView!
    
    var uiButtons: [UIButton] { [TimerButton, SeeAreasButton, TutorialButton, CameraButton] }
    var uiLabels: [UILabel] { [TimerLabel, SeeAreasLabel, TutorialLabel, CameraLabel] }
    
    //MARK: VARIABLES
    private var lastFrame = Date()
    
    private var seeAreas: Bool = true {
        didSet {
            if self.seeAreas {
                self.SeeAreasButton.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                self.SeeAreasButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        }
    }
    
    private var rootLayer: CALayer!
    private var detectionLayer: CALayer!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
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
        self.music = mockMusics.first!
        
        if !IS_SIMULATOR{
            self.setupVision()
            self.start()
        }
    }
    
    func checkDebugMode() {
        if DEBUG_MODE {
            FpsLabel.alpha = 1
            FpsLabel.isHidden = false
        } else {
            FpsLabel.alpha = 0
            FpsLabel.isHidden = true
        }
        
    }
    
    //MARK: CAROUSEL CONFIGURATION
    
    let CarouselView: iCarousel = {
        let view = iCarousel()
        view.type = .linear
        return view
    }()
    
    func setupCarousel(){
        self.CarouselBackgroundView.addSubview(self.CarouselView)
        self.CarouselView.frame = self.CarouselBackgroundView.frame
        self.CarouselView.center.x = view.frame.midX
        self.CarouselView.dataSource = self
        self.CarouselView.delegate = self
        self.CarouselView.stopAtItemBoundary = true
        
        print("Carousel Criado")
        self.CarouselView.scrollToItem(at: (3), animated: true)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return mockMusics.count
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.CarouselView.reloadData()
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 2
        default: return value
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var view = UIView()
    
        switch index {
        case self.CarouselView.currentItemIndex:
            view = setupCarouselItemView(item: mockMusics[index], size : 72, position: "first")
            
        case self.CarouselView.currentItemIndex - 1:
            view = setupCarouselItemView(item: mockMusics[index], size : 40, position: "second")
          
        case self.CarouselView.currentItemIndex + 1:
            view = setupCarouselItemView(item: mockMusics[index], size : 40, position: "second")
            
        default:
            view = setupCarouselItemView(item: mockMusics[index], size : 32, position: "third")
        }
//        print(view.center)
        return view
    }
    
    func setupCarouselItemView(item : MusicModel, size : Double, position : String) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size, height: 104))
        
        if position == "first"{
            let vieww = SelectedMusicView()
            vieww.music = item
            view.addSubview(vieww)
            return view
        }
        
        let circleView = UIView()
        
        
        view.addSubview(circleView)
        circleView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        circleView.backgroundColor = item.color
        circleView.layer.cornerRadius = size / 2
        circleView.clipsToBounds = true
        
        let recordButton = UIButton()
        recordButton.frame = circleView.frame
        recordButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        recordButton.isUserInteractionEnabled = true
        view.addSubview(recordButton)
        
        let categoryContainerView = UIView()
        categoryContainerView.frame = CGRect(x: 0, y: 82, width: size, height: 22)
        categoryContainerView.layer.cornerRadius = 12
        categoryContainerView.backgroundColor = item.color
        if position == "first" {view.addSubview(categoryContainerView)}
        
        let categoryNameLabel = UILabel()
        view.addSubview(categoryNameLabel)
        categoryNameLabel.text = item.name
        categoryNameLabel.font = UIFont(name: "system-bold", size: 10)
        categoryNameLabel.textColor = .white
        categoryNameLabel.textAlignment = .center
        categoryNameLabel.frame = CGRect(x: 2, y: 82, width: size-2, height: 22)
        categoryNameLabel.numberOfLines = 1
        categoryNameLabel.adjustsFontSizeToFitWidth = true
        categoryNameLabel.minimumScaleFactor = 0.1
        
        return view
    }
    
    @objc func pressed() {
        print("Gravandoo")
    }
    
    
    //MARK: CAPTURE SESSION
    private let session = AVCaptureSession()
    private var output = AVCaptureVideoDataOutput()
    private let outputQueue = DispatchQueue(label: "pr.puc.ada.MotionMusic.queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private var bufferSize: CGSize = .zero
    
    func start() {
        session.startRunning()
    }
    
    func stop() {
        session.stopRunning()
    }
    
    func teardown() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func configSession() {
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        
        guard self.createInput(position: .front) else { return }
        guard self.addOutput() else { return }
        
        session.commitConfiguration()
        
        self.configVideoLayer()
        
        print("COMPLETE")
    }
    
    func configVideoLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = PreviewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    func addOutput() -> Bool {
        if session.canAddOutput(output) {
            session.addOutput(output)
            
            output.alwaysDiscardsLateVideoFrames = true
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            output.setSampleBufferDelegate(self, queue: outputQueue)
            
            
        } else {
            printError("Add video data output")
            session.commitConfiguration()
            return false
        }
        
        output.connection(with: .video)?.isEnabled = true
        return true
    }
    
    @discardableResult func createInput(position: AVCaptureDevice.Position) -> Bool {
        var input: AVCaptureDeviceInput!
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position).devices.first
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch {
            printError("Create video device input", error)
            return false
        }
        
        guard self.addInput(input) else { return false }
        
        do {
            try device!.lockForConfiguration()
            
            let dimensions = CMVideoFormatDescriptionGetDimensions((device?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            
            device!.unlockForConfiguration()
        } catch {
            printError("Video Format Description", error)
            return false
        }
        return true
    }
    
    func addInput(_ input: AVCaptureInput) -> Bool {
        guard session.canAddInput(input) else {
            printError("Add video device input")
            session.commitConfiguration()
            return false
        }
        session.addInput(input)
        return true
    }
    
    func setupLayers() {
        detectionLayer = CALayer() // container layer that has all the renderings of the observations
        detectionLayer.name = "detectionLayer"
        detectionLayer.bounds = CGRect(
            x: 0.0,
            y: 0.0,
            width: bufferSize.width,
            height: bufferSize.height
        )
        detectionLayer.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionLayer)
        self.updateLayerGeometry()
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        detectionLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: scale))
        // center the layer
        detectionLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
    }
    
    //MARK: VISION
    
    var points = [String: PointGroupModel<AnyHashable>]()
    
    var requests = [VNRequest]()
    
    func setupVision() {
        self.requests = [
            VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler),
            VNDetectHumanHandPoseRequest(completionHandler: handPoseHandler)
        ]
    }
    
    func handPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanHandPoseObservation], error == nil else { return printError("Hand Pose Request", error) }
        
        observations.forEach { processHandPose($0) }
    }
    
    func processHandPose(_ observation: VNHumanHandPoseObservation) {
        guard let recognizedPoints = try? observation.recognizedPoints(.all) else { return }
        
        var imagePoints = [VNHumanHandPoseObservation.JointName : CGPoint]()
        
        let joints: [VNHumanHandPoseObservation.JointName] = [
            .indexTip, .indexMCP, .ringTip, .ringMCP, .thumbTip, .thumbCMC, .middleTip, .middleMCP, .littleTip, .littleMCP, .wrist
        ]
        
        recognizedPoints.forEach { joint, point in
            guard point.confidence > 0.5, joints.contains(joint) else { return }
            let normalized = VNImagePointForNormalizedPoint(point.location, Int(bufferSize.width), Int(bufferSize.height))
            imagePoints[joint] = normalized
        }
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanBodyPoseObservation], error == nil else { return printError("Body Pose Request", error) }
        
        observations.forEach { processBodyPose($0) }
    }
    
    func processBodyPose(_ observation: VNHumanBodyPoseObservation) {
        guard let recognizedPoints = try? observation.recognizedPoints(.all) else { return }
        
        var imagePoints = [VNHumanBodyPoseObservation.JointName : CGPoint]()
        
        let joints: [VNHumanBodyPoseObservation.JointName] = [
            .leftAnkle,
            .leftElbow,
            .leftHip,
            .leftKnee,
            .rightAnkle,
            .rightElbow,
            .rightHip,
            .rightKnee,
            .root,
            //            .leftEar,
            //            .rightEar,
            //            .nose,
            
        ]
        
        recognizedPoints.forEach { joint, point in
            guard point.confidence > 0.5, joints.contains(joint) else { return }
            let normalized = VNImagePointForNormalizedPoint(point.location, Int(bufferSize.width), Int(bufferSize.height))
            imagePoints[joint] = normalized
        }
        
        if let leftHand = recognizedPoints[.leftWrist], let rightHand = recognizedPoints[.rightWrist] {
            if leftHand.confidence > 0.5 && rightHand.confidence > 0.5 {
                let lH = VNImagePointForNormalizedPoint(leftHand.location, Int(bufferSize.width), Int(bufferSize.height))
                let rH = VNImagePointForNormalizedPoint(rightHand.location, Int(bufferSize.width), Int(bufferSize.height))
                let distance = lH.distance(to: rH)
                if distance < 30 {
                    if !self.isClapping {
                        self.isClapping = true
                        self.onClap()
                    }
                } else {
                    self.isClapping = false
                }
            }
        }
        
        points["Body"] = PointGroupModel(points: imagePoints, radius: 12, color: UIColor.blue.cgColor)
        
        if DEBUG_MODE { DispatchQueue.main.async { self.drawPoints() } }
    }
    
    func drawPoints() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionLayer.sublayers = nil
        
        points.forEach { key, group in
            self.draw(points: group.pointArray, radius: group.radius, color: group.color)
        }
        
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func draw(points: [CGPoint], radius: CGFloat, color: CGColor) {
        for point in points {
            let layer = CAShapeLayer()
            layer.position = CGPoint(x: point.x, y: point.y)
            layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: radius, height: radius), cornerRadius: radius / 2).cgPath
            layer.fillColor = color
            self.detectionLayer.addSublayer(layer)
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) { }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if DEBUG_MODE {
            let diff = self.lastFrame.distance(to: Date())
            if (diff != 0) {
                DispatchQueue.main.async {
                    let fps_value = Int((1 / diff).rounded())
                    
                    self.FpsLabel.text = "\(fps_value) FPS"
                    self.lastFrame = Date()
                }
            }
        }
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return printError("Buffer is Nil") }
        
        let exif = exifOrientationFromDeviceOrientation()
        let imgRequestHandler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: exif, options: [:])
        do { try imgRequestHandler.perform(self.requests) } catch { printError("Vision Handler", error) }
    }
    
    //MARK: SOUNDS
    
    let engine = AudioEngine()
    let sampler = AppleSampler()
    
    func startAudio() {
        engine.output = sampler
        do {
            try engine.start()
        } catch {
            printError("Start AudioKit", error)
        }
    }
    
    func playSound(_ controller: SoundButtonController) {
        sampler.play(noteNumber: MIDINoteNumber(controller.note))
    }
    
    func stopSound() {
        sampler.stop()
    }
    
    func loadFiles() {
        do {
            let files = soundControllers.compactMap { $0.audio }
            try sampler.loadAudioFiles(files)
        } catch {
            printError("Load Files", error)
        }
    }
    
    func stopAudio() {
        engine.stop()
    }
    
    var isClapping = false
    
    func onClap() {
        print("clap")
        if let controller = soundControllers.first(where: { $0.type == .Clap }) {
            playSound(controller)
        }
    }
    
    //MARK: RECORDING
    
    let recorder = RPScreenRecorder.shared()
    
    var isRecording = false { didSet { updateRecordingUI() } }
    
    func updateRecordingUI() {
        UIView.animate(withDuration: 0.5) {
            if self.isRecording {
                self.uiLabels.forEach { $0.alpha = 0 }
                self.uiButtons.forEach { $0.alpha = 0 }
            } else {
                self.uiLabels.forEach { $0.alpha = 1 }
                self.uiButtons.forEach { $0.alpha = 1 }
            }
        }
    }
    
    @IBAction func startStopRecording(_ sender: Any) {
        if isRecording {
            let temp = getTempURL(fileExtension: "mp4")
            let final = getURL(for: .documentDirectory, fileExtension: "mov")
            
            let factor = self.BottomView.frame.height / self.PreviewView.frame.height
            
            recorder.stopRecording(withOutput: temp) { error in
                guard error == nil else { return printError("Stop Recording") }
                print("Finished Recording!")
                self.isRecording = false
                let item = AVPlayerItem(asset: AVAsset(url: temp))
                if let size = item.asset.videoSize {
                    let rect = CGRect(x: 0, y: size.height * factor, width: size.width, height: size.height * (1 - factor))
                    self.transformVideo(item: item, outputUrl: final, cropRect: rect)
                }
            }
        } else {
            guard recorder.isAvailable else { return printError("Recorder Unavailable") }
            recorder.isMicrophoneEnabled = false
            recorder.startRecording { error in
                guard error == nil else { return printError("Start Recording", error) }
                self.isRecording = true
                print("Started Recording!")
            }
        }
    }
    
    func transformVideo(item: AVPlayerItem, outputUrl: URL, cropRect: CGRect) {
        let cropScaleComposition = AVMutableVideoComposition(asset: item.asset, applyingCIFiltersWithHandler: {request in
            let cropFilter = CIFilter(name: "CICrop")! //1
            cropFilter.setValue(request.sourceImage, forKey: kCIInputImageKey) //2
            cropFilter.setValue(CIVector(cgRect: cropRect), forKey: "inputRectangle")
            
            
            let imageAtOrigin = cropFilter.outputImage!.transformed(by: CGAffineTransform(translationX: -cropRect.origin.x, y: -cropRect.origin.y)) //3
            
            request.finish(with: imageAtOrigin, context: nil) //4
        })
        
        cropScaleComposition.renderSize = cropRect.size //5
        item.videoComposition = cropScaleComposition  //6
        
        let exporter = AVAssetExportSession(asset: item.asset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = cropScaleComposition
        exporter.outputURL = outputUrl
        exporter.outputFileType = .mov
        
        exporter.exportAsynchronously(completionHandler: {
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputUrl) }) { saved, error in
                guard error == nil else { return printError("Save Video", error) }
                if saved { print("Saved") }
            }
        })
    }
    
    //MARK: MOTION MUSIC
    
    var music: MusicModel = mockMusics.first! { didSet { updateSoundControllers() } }
    
    var soundControllers = [SoundButtonController]()
    
    func updateSoundControllers() {
        soundControllers = music.buttons.compactMap({ SoundButtonController($0) })
        
        loadFiles()
        createSoundButtons()
    }
    
    func createSoundButtons() {
//        self.busy = true
        self.SoundButtonsView.subviews.forEach { $0.removeFromSuperview() }
        let width = self.SoundButtonsView.frame.width
        let height = self.SoundButtonsView.frame.height
        for controller in soundControllers {
            let x = CGFloat(controller.position.x * width)
            let y = CGFloat(controller.position.y * height)
            let radius = CGFloat(controller.radius * width)
            let button = UIView(frame: CGRect(x: x - radius, y: y - radius, width: 2 * radius, height: 2 * radius))
            button.backgroundColor = controller.color
            button.alpha = 0.5
            button.layer.cornerRadius = radius
            self.SoundButtonsView.addSubview(button)
        }
    }
    
    func checkPoints(points: [CGPoint], controller: SoundButtonController) -> Bool {
        for point in points {
            let dx = point.x - controller.position.x
            let dy = point.y - controller.position.y
            let dist = pow(dx, 2) + pow(dy, 2)
            let radius = pow(controller.radius, 2) + 0.025
            if dist <= radius { return true }
        }
        return false
    }
    
    //MARK: UI BUTTONS
    
    @IBAction func onSwitchCamera(_ sender: Any) {
        guard let currentInput: AVCaptureInput = session.inputs.first else { return }
        
        session.beginConfiguration()
        session.removeInput(currentInput)
        
        if (currentInput as! AVCaptureDeviceInput).device.position == .front { self.createInput(position: .back) }
        else { self.createInput(position: .front) }
        session.commitConfiguration()
    }
    
    @IBAction func onTutorial(_ sender: Any) {
        
    }
    
    @IBAction func onSeeAreas(_ sender: Any) {
        seeAreas.toggle()
    }
    
    @IBAction func onTimer(_ sender: Any) {
        
    }
}
