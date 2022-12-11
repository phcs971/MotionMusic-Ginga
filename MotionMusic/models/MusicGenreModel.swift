//
//  MusicGenreMode.swift
//  MotionMusic
//
//  Created by Bruno Imai on 16/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MusicGenreModel: Equatable, Identifiable, Codable {
    static func == (lhs: MusicGenreModel, rhs: MusicGenreModel) -> Bool { lhs.id == rhs.id }
    
    @DocumentID var id: String? = UUID().uuidString
    
    var name: String
    
    var active: Bool = true
    
    var musicIds = [String]()
    
    var musics: [MusicModel] {
        musicIds.compactMap { id in DatabaseService.instance.musics.first { $0.id == id } }
    }
//    var musics: [MusicModel] { danceMusics } 
//    var musics = danceMusics
    
}

let mockMusicsGenre = [
        MusicGenreModel(id: "DANCE", name: "DANCE", musicIds: ["alors_on_danse"]),
        MusicGenreModel(id: "ETC", name: "OUTROS", musicIds: ["drum_kit"]),
//        MusicGenreModel(id: "DANCE", name: "DANCE", musics: danceMusics),
//        MusicGenreModel(id: "ETC", name: "OUTROS", musics: miscMusics),
//    MusicGenreModel(id: "POP", name: "POP", musics: mockMusics, color: .systemPurple),
]
