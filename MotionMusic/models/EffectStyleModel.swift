//
//  StyleModel.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct EffectStyleModel: Equatable, Identifiable, Codable {
    static func == (lhs: EffectStyleModel, rhs: EffectStyleModel) -> Bool { lhs.id == rhs.id }
    
    @DocumentID var id: String? = UUID().uuidString
    
    var animationCode: String
    
    var name: String
    
    var colorsHex: [Int]
        
    var showAnimation: Bool = true
    
    var active: Bool = true
    
    var colors: [UIColor] { colorsHex.map { UIColor(rgb: $0) } }
}

let mockEffects = [
    EffectStyleModel(animationCode: "none", name: "Nenhum", colorsHex: [0x575757, 0x575757, 0x575757], showAnimation: false),
    EffectStyleModel(animationCode: "ginga", name: "Ginga", colorsHex: [8908693, 6254068, 14707368]),
    EffectStyleModel(animationCode: "sunset", name: "Sunset",  colorsHex: [0xFFEF5C, 0xFFA451, 0xFD6182]),
    EffectStyleModel(animationCode: "trevoso", name: "Trevoso",  colorsHex: [0x0E071F, 0x4770FF, 0xF36AFF]),
    EffectStyleModel(animationCode: "primarias", name: "Chiclete",  colorsHex: [0xFFEF5C, 0xFF6AC3, 0x5CCFEE]),
]

