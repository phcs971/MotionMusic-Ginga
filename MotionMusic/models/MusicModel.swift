//
//  MusicModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit

struct MusicModel: Equatable, Identifiable {
    static func == (lhs: MusicModel, rhs: MusicModel) -> Bool { lhs.id == rhs.id }
    
    var id: String = UUID().uuidString
    
    var name: String
    
    var authorName: String
    
    var buttons = [SoundButtonModel]()
    
    
    var bpm: Double
    
    var interval: TimeInterval { 60.0 / bpm }
    
}

let danceMusics = [
    MusicModel(id: "alors_on_danse", name: "Alors on Danse", authorName: "Stromae", buttons: alorsOnDanse, bpm: 119),
]

let miscMusics = [
    MusicModel(id: "drum_kit", name: "Bateria", authorName: "Ginga", buttons: drumsSet, bpm: 120),
]

let mockMusics = [
    MusicModel(id: "music1", name: "Born to run", authorName: "IZA", buttons: mockButtons, bpm: 120),
    MusicModel(id: "music2", name: "Closer", authorName: "IZA", buttons: mockButtons2, bpm: 60),
    MusicModel(id: "music3", name: "Call me maybe", authorName: "IZA", buttons: mockButtons, bpm: 100),
    MusicModel(id: "music4", name: "Carry On", authorName: "IZA", buttons: mockButtons2, bpm: 80),
]
