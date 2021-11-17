//
//  StyleModel.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit

struct StyleModel: Equatable, Identifiable {
    static func == (lhs: StyleModel, rhs: StyleModel) -> Bool { lhs.id == rhs.id }
    
    var id: String = UUID().uuidString
    
    var name: String
    
    var color: UIColor
    
}


#if DEBUG

let mockStyles = [
    MusicGenreModel(name: "Basico", color: .gray),
    MusicGenreModel(name: "Sunset", color: .red),
    MusicGenreModel(name: "Trevoso", color: .purple),
]

#endif
