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
    
}

#if DEBUG

let mockMusics = [
    MusicModel(name: "Pop", buttons: mockButtons, color: .blue),
    MusicModel(name: "Rock", buttons: mockButtons, color: .red),
    MusicModel(name: "Funk", buttons: mockButtons, color: .yellow),
    MusicModel(name: "Dance", buttons: mockButtons, color: .purple),
    MusicModel(name: "Reggae", buttons: mockButtons, color: .green),
    MusicModel(name: "Eletrônica", buttons: mockButtons, color: .orange),
    MusicModel(name: "Bateria", buttons: mockButtons, color: .brown),
]

#endif
