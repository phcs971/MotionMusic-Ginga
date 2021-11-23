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

let mockMusics0 = [
    MusicModel(name: "Alors on Danse", authorName: "Stromae", buttons: alorsOnDanse, bpm: 119),
    MusicModel(name: "Bateria", authorName: "Ginga", buttons: drumsSet, bpm: 120),
    ]

let mockMusics1 = [
    MusicModel(name: "Born to run", authorName: "IZA", buttons: mockButtons, bpm: 120),
    MusicModel(name: "Closer", authorName: "IZA", buttons: mockButtons, bpm: 120),
    MusicModel(name: "Call me maybe", authorName: "IZA", buttons: mockButtons, bpm: 120),
    ]
let mockMusics2 = [
    MusicModel(name: "Carry On", authorName: "IZA", buttons: mockButtons, bpm: 120),
    MusicModel(name: "Reggae", authorName: "IZA", buttons: mockButtons, bpm: 120),
    MusicModel(name: "Eletrônica", authorName: "IZA", buttons: mockButtons, bpm: 120),
]
