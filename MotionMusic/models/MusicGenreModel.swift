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


#if DEBUG

let mockMusicsGenre = [
    MusicGenreModel(name: "POP", musics: mockMusics, color: .blue),
    MusicGenreModel(name: "ROCK", musics: mockMusics, color: .red),
    MusicGenreModel(name: "SERTANEJO?", musics: mockMusics, color: .yellow),
]

#endif
