//
//  StyleModel.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit

struct EffectStyleModel: Equatable, Identifiable {
    static func == (lhs: EffectStyleModel, rhs: EffectStyleModel) -> Bool { lhs.id == rhs.id }
    
    var id: String = UUID().uuidString
    
    var name: String
    
    var color: UIColor
    
}

let mockEffects = [
    EffectStyleModel(name: "Basico", color: .gray),
    EffectStyleModel(name: "Sunset", color: .red),
    EffectStyleModel(name: "Trevoso", color: .purple),
]
