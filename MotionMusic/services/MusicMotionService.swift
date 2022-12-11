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
    
    var didSetEffects = [Int: (() -> Void)]()
    
    var willSetMusic = [Int: (() -> Void)]()
    
    static let instance = MusicMotionService()
    
    var genre: MusicGenreModel { didSet { musics = genre.musics; self.didSetGenre.values.forEach { $0() } } }
    var music: MusicModel {
        willSet { self.willSetMusic.values.forEach { $0() } }
        didSet { self.didSetMusic.values.forEach { $0() } }
    }
    var effect: EffectStyleModel {
        didSet {
            self.didSetEffect.values.forEach { $0() }   
        }
    }
    
    var effects = [EffectStyleModel]() {
        didSet {
            self.didSetEffects.values.forEach { $0() }
            effect = effects.first { $0.id == SettingsService.instance.effectId } ?? effects.first { $0.showAnimation }!
        }
    }
    
    var genres = [MusicGenreModel]() {
        didSet {
            genre = genres.first!
        }
    }
    
    var musics = [MusicModel]() {
        didSet {
            music = musics.first!
        }
    }
    
    func updateDefaults() {
        effect = effects.first(where: { $0.id == SettingsService.instance.effectId }) ?? effect
        genre = genres.first(where: { $0.id == SettingsService.instance.genreId }) ?? genre
        music = musics.first(where: { $0.id == SettingsService.instance.musicId }) ?? music
    }
}
