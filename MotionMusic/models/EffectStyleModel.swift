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
    EffectStyleModel(name: "Nenhum", colors: [.gray, .gray], showAnimation: false),
    EffectStyleModel(id: "ginga", name: "Ginga", colors: [#colorLiteral(red: 0.5286026597, green: 0.9359915257, blue: 0.5859673619, alpha: 1), #colorLiteral(red: 0.3740813136, green: 0.4281770587, blue: 0.9578273892, alpha: 1), #colorLiteral(red: 0.8764852285, green: 0.4163866043, blue: 0.6601393819, alpha: 1)]),
    EffectStyleModel(id: "sunset", name: "Sunset",  colors: [#colorLiteral(red: 1, green: 0.9374610782, blue: 0.3620254695, alpha: 1), #colorLiteral(red: 0.9888160825, green: 0.6351911426, blue: 0.3159540892, alpha: 1), #colorLiteral(red: 0.9905835986, green: 0.3816677928, blue: 0.5077443719, alpha: 1)]),
    EffectStyleModel(id: "trevoso", name: "Trevoso",  colors: [#colorLiteral(red: 0.05610793829, green: 0.02776246145, blue: 0.1231660023, alpha: 1), #colorLiteral(red: 0.2785869837, green: 0.4369585812, blue: 0.9991567731, alpha: 1), #colorLiteral(red: 0.9522402883, green: 0.4175275266, blue: 1, alpha: 1)]),
    EffectStyleModel(id: "chiclete", name: "Chiclete",  colors: [#colorLiteral(red: 1, green: 0.937254902, blue: 0.3607843137, alpha: 1), #colorLiteral(red: 1, green: 0.4156862745, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.3607843137, green: 0.8117647059, blue: 0.9333333333, alpha: 1)]),
]

