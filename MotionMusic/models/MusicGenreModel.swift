//
//  MusicGenreMode.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit

struct MusicGenreModel: Equatable, Identifiable {
    static func == (lhs: MusicGenreModel, rhs: MusicGenreModel) -> Bool { lhs.id == rhs.id }
    
    var id: String = UUID().uuidString
    
    var name: String
    
    var musics = [MusicModel]()
    
    var color: UIColor
    
}

let mockMusicsGenre = [
    MusicGenreModel(id: "DANCE", name: "DANCE", musics: danceMusics, color: .systemBlue),
    MusicGenreModel(id: "ETC", name: "OUTROS", musics: miscMusics, color: .systemRed),
//    MusicGenreModel(id: "POP", name: "POP", musics: mockMusics, color: .systemPurple),
]
