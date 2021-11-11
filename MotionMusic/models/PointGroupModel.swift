//
//  PointGroupModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 08/11/21.
//

import UIKit

struct PointGroupModel<Element: Hashable> {
    var points: [Element: CGPoint]
    var percentPoints: [CGPoint]
    
    var radius: CGFloat
    
    var color: CGColor
    
    var pointArray: [CGPoint] { points.values.map{ $0 } }
}
