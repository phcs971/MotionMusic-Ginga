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
    
    var color: UIColor
    
    var bpm: Double
    
    var interval: TimeInterval { 60.0 / bpm }
    
}

let mockMusics = [
    MusicModel(name: "Alors on Danse", authorName: "Stromae", buttons: alorsOnDanse, color: .yellow, bpm: 119),
    MusicModel(name: "Bateria", authorName: "Ginga", buttons: drumsSet, color: .brown, bpm: 120),
    MusicModel(name: "Born to run", authorName: "IZA", buttons: mockButtons, color: .blue, bpm: 120),
    MusicModel(name: "Closer", authorName: "IZA", buttons: mockButtons, color: .red, bpm: 120),
    MusicModel(name: "Call me maybe", authorName: "IZA", buttons: mockButtons, color: .yellow, bpm: 120),
    MusicModel(name: "Carry On", authorName: "IZA", buttons: mockButtons, color: .purple, bpm: 120),
    MusicModel(name: "Reggae", authorName: "IZA", buttons: mockButtons, color: .green, bpm: 120),
    MusicModel(name: "Eletrônica", authorName: "IZA", buttons: mockButtons, color: .orange, bpm: 120),
]
