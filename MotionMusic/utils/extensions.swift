//
//  extensions.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import AVFoundation

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        sqrt(pow(self.x - other.x, 2) + pow(self.y - other.y, 2))
    }
}

extension AVAsset {
    var videoSize: CGSize? {
        tracks(withMediaType: .video).first.flatMap {
            tracks.count > 0 ? $0.naturalSize.applying($0.preferredTransform) : nil
        }
    }
}
