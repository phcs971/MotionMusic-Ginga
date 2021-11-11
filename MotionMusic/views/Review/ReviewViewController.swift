//
//  ReviewViewController.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import AVFoundation
import Photos

class ReviewViewController: UIViewController {

    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var VideoView: UIView!
    @IBOutlet weak var ReturnToSafeAreaConstraint: NSLayoutConstraint!
    
    var url: URL!
    var playerLooper: AVPlayerLooper! // should be defined in class
    var queuePlayer: AVQueuePlayer!
    
    var saved: Bool = false {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.SaveButton.alpha = self.saved ? 0 : 1
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupPlayer()
        queuePlayer.play()
    }
    
    func setupPlayer() {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: item)
        self.playerLooper = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        let videoSize = asset.videoSize!
        let viewSize = self.VideoView.bounds
        let height = viewSize.width * videoSize.height / videoSize.width
        playerLayer.frame = CGRect(x: 0, y: viewSize.height - height, width: viewSize.width, height: height)
        self.VideoView.layer.addSublayer(playerLayer)
        
        ReturnToSafeAreaConstraint.constant = viewSize.height - height + 12 - self.view.safeAreaInsets.top
        self.view.layoutIfNeeded()
    }
    
    @IBAction func save(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.url) }) { saved, error in
            guard error == nil else { return printError("Save Video", error) }
            if saved {
                print("Saved")
                self.saved = true
            }
        }
    }
    
    func delete() {
        self.dismiss(animated: true)
    }
    
    @IBAction func share(_ sender: Any) {
        
        var files = [Any]()
        files.append(url as Any)
        let vc = UIActivityViewController(activityItems: files, applicationActivities: nil)
        self.present(vc, animated: true)
    }
    
    @IBAction func pop(_ sender: Any) {
        //Confirmar com usuário
        self.delete()
    }
}
