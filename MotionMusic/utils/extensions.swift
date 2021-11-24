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
    
    func midPoint(to other: CGPoint) -> CGPoint {
        CGPoint(x: (self.x + other.x) / 2, y: (self.y + other.y) / 2)
    }
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
  left = left + right
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func -= (left: inout CGPoint, right: CGPoint) {
  left = left - right
}

extension AVAsset {
    var videoSize: CGSize? {
        tracks(withMediaType: .video).first.flatMap {
            tracks.count > 0 ? $0.naturalSize.applying($0.preferredTransform) : nil
        }
    }
}

extension UIView {
    var mm: MusicMotionService { MusicMotionService.instance }
}

extension UIViewController {
    var mm: MusicMotionService { MusicMotionService.instance }
}
