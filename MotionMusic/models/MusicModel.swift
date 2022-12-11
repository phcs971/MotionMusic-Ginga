//
//  MusicModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MusicModel: Equatable, Identifiable, Codable {
    static func == (lhs: MusicModel, rhs: MusicModel) -> Bool { lhs.id == rhs.id }
    
    @DocumentID var id: String? = UUID().uuidString
    
    var name: String
    var authorName: String
    var bpm: Double
    
    var active: Bool = true
    
    var musicDots = [SoundButtonModel]()
    
    var interval: TimeInterval { 60.0 / bpm }
    
}

let danceMusics = [
    MusicModel(id: "alors_on_danse", name: "Alors on Danse", authorName: "Stromae", bpm: 119, musicDots: alorsOnDanse),
]

let miscMusics = [
    MusicModel(id: "drum_kit", name: "Bateria", authorName: "Ginga", bpm: 120, musicDots: drumsSet),
]

//let mockMusics = [
//    MusicModel(id: "music1", name: "Born to run", authorName: "IZA", bpm: 120, musicDots: mockButtons),
//    MusicModel(id: "music2", name: "Closer", authorName: "IZA", bpm: 60, musicDots: mockButtons2),
//    MusicModel(id: "music3", name: "Call me maybe", authorName: "IZA", bpm: 100, musicDots: mockButtons),
//    MusicModel(id: "music4", name: "Carry On", authorName: "IZA", bpm: 80, musicDots: mockButtons2),
//]
