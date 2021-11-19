//
//  MusicMotionService.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 17/11/21.
//

import Foundation

class MusicMotionService {
    private init() {
        effects = mockEffects
        genres = mockMusicsGenre
        musics = mockMusicsGenre.first!.musics
        
        effect = mockEffects.first!
        genre = mockMusicsGenre.first!
        music = mockMusicsGenre.first!.musics.first!
    }
    
    var didSetMusic = [Int: (() -> Void)]()
    var didSetGenre = [Int: (() -> Void)]()
    var didSetEffect = [Int: (() -> Void)]()
    
    static let instance = MusicMotionService()
    
    var genre: MusicGenreModel { didSet { musics = genre.musics; self.didSetGenre.values.forEach { $0() } } }
    var music: MusicModel { didSet { self.didSetMusic.values.forEach { $0() } } }
    var effect: EffectStyleModel { didSet { self.didSetEffect.values.forEach { $0() } } }
    
    var effects = [EffectStyleModel]() { didSet { effect = effects.first! } }
    var genres = [MusicGenreModel]() { didSet { genre = genres.first! } }
    var musics = [MusicModel]() { didSet { music = musics.first! } }
}
