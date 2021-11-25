//
//  ReviewViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AVFoundation
import Photos
import ToastViewSwift

class ReviewViewController: UIViewController {

    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var VideoView: UIView!
    @IBOutlet weak var ReturnToSafeAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var VolumeButton: UIButton!
    @IBOutlet weak var PauseButton: UIImageView!
    @IBOutlet weak var TopView: UIView!
    
    
    var url: URL!
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    
    var videoSize: CGSize!
    var viewSize: CGSize!
    var height: CGFloat!
    
    var loaded = false
    
    var soundEnabled: Bool = false {
        didSet {
            queuePlayer.volume = soundEnabled ? 1 : 0
            DispatchQueue.main.async {
                self.VolumeButton.setImage(UIImage(
                    systemName: self.soundEnabled ? "speaker.wave.3" : "speaker.slash"
                ), for: .normal)
            }
        }
    }
    
    var saved: Bool = false
    
    var pause: Bool = false {
        didSet {
            if pause {
                queuePlayer.pause()
            } else {
                queuePlayer.play()
            }
            DispatchQueue.main.async {
                self.PauseButton.image = UIImage(systemName: self.pause ? "pause.fill" : "play.fill")
                UIView.animate(withDuration: 0.5, delay: 0.25) {
                    self.PauseButton.alpha = self.pause ? 0.75 : 0
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupPlayer()
        setupVideoView()
        queuePlayer.play()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        ReturnToSafeAreaConstraint.constant = viewSize.height - height + 12 - self.view.safeAreaInsets.top
        self.view.layoutIfNeeded()
    }
    
    func setupPlayer() {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: item)
        self.playerLooper = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        videoSize = asset.videoSize!
        viewSize = self.VideoView.bounds.size
        height = viewSize.width * videoSize.height / videoSize.width
        playerLayer.frame = CGRect(x: 0, y: viewSize.height - height, width: viewSize.width, height: height)
        self.VideoView.layer.addSublayer(playerLayer)
        loaded = true
    }
    
    func setupVideoView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.pausePlay(_:)))
        self.VideoView.addGestureRecognizer(gesture)
        self.VideoView.bringSubviewToFront(self.PauseButton)
    }
    
    @IBAction func save(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.url) }) { saved, error in
            guard error == nil else { return printError("Save Video", error) }
            if saved {
                print("Saved")
                self.saved = true
                let toast = Toast.text("Salvo")
                toast.show()
            }
        }
    }
    
    func delete() {
        try? FileManager.default.removeItem(at: url)
        self.dismiss(animated: true)
    }
    
    @objc func pausePlay(_ sender: Any) { if loaded { pause.toggle() } }
    
    @IBAction func toggleSound(_ sender: Any) { if loaded { soundEnabled.toggle() } }
    
    @IBAction func share(_ sender: Any) {
        var files = [Any]()
        files.append(url as Any)
        let vc = UIActivityViewController(activityItems: files, applicationActivities: nil)
        self.present(vc, animated: true)
    }
    
    @IBAction func pop(_ sender: Any) {
        if saved {
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(
                title: "Deseja mesmo excluir?",
                message: "Você vai perder tudinho",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Excluir",
                style: .destructive,
                handler: { _ in self.delete() }
            ))
            alert.addAction(UIAlertAction(
                title: "Cancelar",
                style: .cancel
            ))
            self.present(alert, animated: true)
        }
        
    }
}
