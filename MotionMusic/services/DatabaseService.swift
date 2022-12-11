//
//  DatabaseService.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 02/12/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseService {
    private init() {}
    
    static let instance = DatabaseService()
    
    let db = Firestore.firestore()
    
    var mm: MusicMotionService { MusicMotionService.instance }
    
    var hasGenreSnapshot = false
    
    func populate() {
//        uploadGenres(mockMusicsGenre)
//        uploadMusics(danceMusics)
//        uploadMusics(miscMusics)
        getEffects()
        getMusics()
        getGenres()
    }
    
    var musics: [MusicModel] = [ danceMusics[0], miscMusics[0] ]
    
    func uploadMusics(_ musics: [MusicModel]) {
        for music in musics {
            do {
                print("send", music.name)
                let _ = try db.collection("musics").addDocument(from: music)
            } catch {
                printError("SEND MUSIC", error)
            }
        }
    }
    
    func uploadGenres(_ genres: [MusicGenreModel]) {
        for genre in genres {
            do {
                print("send", genre.name)
                let _ = try db.collection("genres").addDocument(from: genre)
            } catch {
                printError("SEND MUSIC", error)
            }
        }
    }
    
    func uploadEffects(_ effects: [EffectStyleModel]) {
        for effect in effects {
            do {
                let _ = try db.collection("effects").addDocument(from: effect)
            } catch {
                printError("SEND EFFECT", error)
            }
        }
    }
    
    func getEffects() {
        db.collection("effects").whereField("active", isEqualTo: true).addSnapshotListener { (query, error) in
            guard let query = query else { return printError("GET EFFECTS", error) }
            let effects: [EffectStyleModel] = query.documents.compactMap({ document in
                return try? document.data(as: EffectStyleModel.self)
            }).sorted(by: { a, b in
                if !a.showAnimation && b.showAnimation { return true }
                return a.name.compare(b.name) == .orderedAscending
            })
            if !effects.isEmpty { self.mm.effects = effects }
        }
    }
    
    func getMusics() {
        db.collection("musics").whereField("active", isEqualTo: true).getDocuments { (query, error) in
            guard let query = query else { return printError("GET MUSICS", error) }
            self.musics = query.documents.compactMap({ document in
                return try? document.data(as: MusicModel.self)
            })
            if !self.hasGenreSnapshot && !self.musics.isEmpty {
                self.hasGenreSnapshot = true
                self.getGenres()
            }
        }
    }
    
    func getGenres() {
        db.collection("genres").whereField("active", isEqualTo: true).getDocuments { (query, error) in
            guard let query = query else { return printError("GET GENRES", error) }
            let genres: [MusicGenreModel] = query.documents.compactMap({ document in
                let result = try? document.data(as: MusicGenreModel.self)
                if result?.musics.isEmpty ?? true { return nil }
                return result
            }).sorted(by: { a, b in
                a.name.compare(b.name) == .orderedAscending
            })
            
            if !genres.isEmpty { self.mm.genres = genres }
        }
    }
}
