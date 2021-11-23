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
    
    var colors: [UIColor]
    
    var showAnimation: Bool = true
    
}

let mockEffects = [
    EffectStyleModel(name: "Nenhum", colors: [.gray, .gray, .gray], showAnimation: false),
    EffectStyleModel(name: "Sunset", colors: [#colorLiteral(red: 1, green: 0.9374610782, blue: 0.3620254695, alpha: 1), #colorLiteral(red: 0.9888160825, green: 0.6351911426, blue: 0.3159540892, alpha: 1), #colorLiteral(red: 0.9905835986, green: 0.3816677928, blue: 0.5077443719, alpha: 1)]),
    EffectStyleModel(name: "Trevoso", colors: [#colorLiteral(red: 0.05610793829, green: 0.02776246145, blue: 0.1231660023, alpha: 1), #colorLiteral(red: 0.2785869837, green: 0.4369585812, blue: 0.9991567731, alpha: 1), #colorLiteral(red: 0.9522402883, green: 0.4175275266, blue: 1, alpha: 1)])
]

