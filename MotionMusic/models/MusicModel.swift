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
    var buttons = [SoundButtonModel]()
    
    var color: UIColor
    
    var bpm: Double
    
    var interval: TimeInterval { 60.0 / bpm }
    
}

let mockMusics = [
    MusicModel(name: "Pop", buttons: mockButtons, color: .blue, bpm: 120),
    MusicModel(name: "Rock", buttons: drumsSet, color: .red, bpm: 120),
    MusicModel(name: "Eletro", buttons: alorsOnDanse, color: .orange, bpm: 119),
    MusicModel(name: "Funk", buttons: mockButtons, color: .yellow, bpm: 120),
    MusicModel(name: "Dance", buttons: mockButtons, color: .purple, bpm: 120),
    MusicModel(name: "Reggae", buttons: mockButtons, color: .green, bpm: 120),
    MusicModel(name: "Bateria", buttons: mockButtons, color: .brown, bpm: 120),
]
