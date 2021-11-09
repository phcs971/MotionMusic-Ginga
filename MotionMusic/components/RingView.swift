//
//  RingView.swift
//  MotionMusic
//
//  Created by Bruno Imai on 09/11/21.
//

import UIKit

@IBDesignable
class RingView: UIView {

    @IBInspectable
    var color: UIColor = .blue {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 8 {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let radius = min(rect.width, rect.height)/2
        let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius - lineWidth/2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        color.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
        
    }


}
