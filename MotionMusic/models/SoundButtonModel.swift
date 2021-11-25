//
//  SoundButtonModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import CloudKit
import AVFoundation
import Lottie

enum SoundInteractionType: Int {
    case Touch = 0
    case Toggle = 1
    case Clap = 2
}

struct SoundButtonModel: Equatable, Identifiable {
    static func == (lhs: SoundButtonModel, rhs: SoundButtonModel) -> Bool { lhs.id == rhs.id }
    
    var id: String = UUID().uuidString
    
    var name: String
    var soundFile: CKAsset
    var note: Int
    
    var color: UIColor
    var image: UIImage?
    
    var position: CGPoint
    
    var radius: CGFloat
    
    var animation: String?
    var animationOffset: CGPoint?
    
    var type: SoundInteractionType
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "SoundButton", recordID: CKRecord.ID(recordName: id))
        record.setValuesForKeys([
            "name": name,
            "x": position.x,
            "y": position.y,
            "radius": radius,
            "type": type.rawValue,
            "note": note,
            "color_red": color.ciColor.red,
            "color_green": color.ciColor.green,
            "color_blue": color.ciColor.blue,
            "soundFile": soundFile,
            "animation": animation ?? "",
            "animation_x": animationOffset?.x ?? 0.0,
            "animation_y": animationOffset?.y ?? 0.0,
        ])
        return record
    }
    
    static func from(record: CKRecord) -> SoundButtonModel {
        let anm = record.value(forKey: "animation") as? String
        let animation = (anm ?? "") == "" ? nil : anm
        return SoundButtonModel(
            id: record.recordID.recordName,
            name: record.value(forKey: "name") as? String ?? "Sem Nome",
            soundFile: record.value(forKey: "soundFile") as! CKAsset,
            note: record.value(forKey: "note") as! Int,
            color: UIColor(ciColor: CIColor(
                red: record.value(forKey: "color_red") as! Double,
                green: record.value(forKey: "color_green") as! Double,
                blue: record.value(forKey: "color_blue") as! Double)
            ),
            position: CGPoint(x: record.value(forKey: "x") as! Double, y: record.value(forKey: "y") as! Double),
            radius: record.value(forKey: "radius") as! Double,
            animation: animation,
            animationOffset: animation == nil ? nil : CGPoint(x: record.value(forKey: "animation_x") as! Double, y: record.value(forKey: "animation_y") as! Double),
            type: SoundInteractionType(rawValue: record.value(forKey: "type") as! Int) ?? .Touch
        )
    }
}

class SoundButtonController: NSObject, Identifiable, AVAudioPlayerDelegate {
    
    static func == (lhs: SoundButtonController, rhs: SoundButtonController) -> Bool { lhs.id == rhs.id }
    
    let soundButton: SoundButtonModel
    
    var id: String { soundButton.id }
    var name: String { soundButton.name }
    var type: SoundInteractionType { soundButton.type }
    var color: UIColor { soundButton.color }
    var note: Int { soundButton.note }
    
    var animation: String? { soundButton.animation }
    var animationOffset: CGPoint? { soundButton.animationOffset }
    
    var position: CGPoint
    var radius: CGFloat
    
    var player: AVAudioPlayer
    var duplicatePlayers = [AVAudioPlayer]()
    
    var isIn = false
    var lastTime = Date()
    
    var animationView: AnimationView?
    var animationPoint: CGPoint?
    var animationSize: CGFloat?
    
    init(_ soundButton: SoundButtonModel) {
        self.soundButton = soundButton
        switch soundButton.type {
        case .Touch, .Toggle:
            self.position = soundButton.position
            self.radius = soundButton.radius
        case .Clap:
            self.position = .zero
            self.radius = 0
        }
        self.player = try! AVAudioPlayer(contentsOf: soundButton.soundFile.fileURL!)
        self.player.prepareToPlay()
    }
    
    var isPlaying = false
    
    func enter() {
        isIn = true
        lastTime = Date()
    }
    
    func leave() {
        isIn = false
    }
    
    func play() {
        if player.isPlaying {
            let newPlayer = try! AVAudioPlayer(contentsOf: player.url!)
            newPlayer.delegate = self
            duplicatePlayers.append(newPlayer)
            newPlayer.prepareToPlay()
            newPlayer.play()
        } else {
            player.prepareToPlay()
            player.play()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.firstIndex(of: player) {
              duplicatePlayers.remove(at: index)
          }
    }
}


let mockButtons: [SoundButtonModel] = [
    SoundButtonModel(
        name: "Clap",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/clap_D#1.wav")),
        note: 27,
        color: .clear,
        position: .zero,
        radius: 0,
        animation: "burst",
        type: .Clap
    ),
    SoundButtonModel(
        name: "Open",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/open_hi_hat_A#1.wav")),
        note: 34,
        color: .systemYellow,
        position: .init(x: 0.2, y: 0.2),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Bass",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/bass_drum_C1.wav")),
        note: 24,
        color: .systemGreen,
        position: .init(x: 0.5, y: 0.9),
        radius: 0.1,
        type: .Touch
    ),
]


let mockButtons2: [SoundButtonModel] = [
    SoundButtonModel(
        name: "Bass",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/bass_drum_C1.wav")),
        note: 24,
        color: .clear,
        position: .zero,
        radius: 0,
        animation: "burst",
        type: .Clap
    ),
    SoundButtonModel(
        name: "Open",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/open_hi_hat_A#1.wav")),
        note: 34,
        color: .systemBlue,
        position: .init(x: 0.6, y: 0.2),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Clap",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/clap_D#1.wav")),
        note: 27,
        color: .systemRed,
        position: .init(x: 0.1, y: 0.9),
        radius: 0.1,
        type: .Touch
    ),
]

let drumsSet: [SoundButtonModel] = [
    SoundButtonModel(
        name: "Clap",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/clap_D#1.wav")),
        note: 27,
        color: .clear,
        position: .zero,
        radius: 0,
        type: .Clap
    ),
    SoundButtonModel(
        name: "Bass",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/bass_drum_C1.wav")),
        note: 24,
        color: .systemGreen,
        position: .init(x: 0.5, y: 0.88),
        radius: 0.12,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Snare",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/snare_D1.wav")),
        note: 26,
        color: .systemPurple,
        position: .init(x: 0.2, y: 0.9),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Low Tom",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/lo_tom_F1.wav")),
        note: 29,
        color: .systemMint,
        position: .init(x: 0.8, y: 0.9),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Open Hat",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/open_hi_hat_A#1.wav")),
        note: 34,
        color: .systemOrange,
        position: .init(x: 0.15, y: 0.6),
        radius: 0.1,
        animation: "burst",
        type: .Touch
    ),
    SoundButtonModel(
        name: "Closed Hat",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/closed_hi_hat_F#1.wav")),
        note: 30,
        color: .systemRed,
        position: .init(x: 0.85, y: 0.6),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "High Tom",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/hi_tom_D2.wav")),
        note: 38,
        color: .systemIndigo,
        position: .init(x: 0.3, y: 0.2),
        radius: 0.075,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Mid Tom",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("drums/mid_tom_B1.wav")),
        note: 35,
        color: .systemBlue,
        position: .init(x: 0.7, y: 0.2),
        radius: 0.075,
        type: .Touch
    ),
]


let alorsOnDanse: [SoundButtonModel] = [
    SoundButtonModel(
        name: "BoomClap",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/LoopBoomClapC1.mp3")),
        note: 24,
        color: .systemRed,
        position: .init(x: 0.25, y: 0.2),
        radius: 0.1,
        animation: "loop1",
        type: .Toggle
    ),
    SoundButtonModel(
        name: "Melodia",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/LoopMelodiaFundoD1.mp3")),
        note: 26,
        color: .systemOrange,
        position: .init(x: 0.75, y: 0.2),
        radius: 0.1,
        animation: "loop2",
        type: .Toggle
    ),
    SoundButtonModel(
        name: "D#3",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxD#3.mp3")),
        note: 51,
        color: .systemGreen,
        position: .init(x: 0.1, y: 0.65),
        radius: 0.075,
        animation: "stars",
        type: .Touch
    ),
    SoundButtonModel(
        name: "C#3",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxC#3.mp3")),
        note: 49,
        color: .systemGreen,
        position: .init(x: 0.9, y: 0.65),
        radius: 0.075,
        animation: "clap",
        type: .Touch
    ),
    SoundButtonModel(
        name: "E3",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxE3.mp3")),
        note: 52,
        color: .systemGreen,
        position: .init(x: 0.1, y: 0.4),
        radius: 0.075,
        animation: "explosion",
        animationOffset: CGPoint(x: 0.1, y: 0),
        type: .Touch
    ),
    SoundButtonModel(
        name: "F#3",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxF#3.mp3")),
        note: 54,
        color: .systemGreen,
        position: .init(x: 0.9, y: 0.4),
        radius: 0.075,
        animation: "lineCircles",
        type: .Touch
    ),
]
