//
//  SoundButtonModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import CloudKit
import AVFoundation

enum SoundInteractionType: Int {
    case Touch = 0
    case Clap = 1
    
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

class SoundButtonController: Equatable, Identifiable {
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
    
    var audio: AVAudioFile
    
    var isIn = false
    var lastTime = Date()
    
    init(_ soundButton: SoundButtonModel) {
        self.soundButton = soundButton
        switch soundButton.type {
        case .Touch:
            self.position = soundButton.position
            self.radius = soundButton.radius
        case .Clap:
            self.position = .zero
            self.radius = 0
        }
        self.audio = try! AVAudioFile(forReading: soundButton.soundFile.fileURL!)
        
    }
    
    func enter() {
        isIn = true
        lastTime = Date()
    }
    
    func leave() {
        isIn = false
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
        animation: "clap",
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
        animation: "clap",
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
        animation: "pop",
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
        animation: "clap",
        animationOffset: CGPoint(x: 0, y: 0),
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
        name: "F#4",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/f#4.mp3")),
        note: 66,
        color: .clear,
        position: .zero,
        radius: 0,
        animation: "pop",
        type: .Clap
    ),
    SoundButtonModel(
        name: "G#3",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/g#3.mp3")),
        note: 56,
        color: .systemRed,
        position: .init(x: 0.2, y: 0.2),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "G#4",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/g#4.mp3")),
        note: 68,
        color: .systemOrange,
        position: .init(x: 0.5, y: 0.2),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "A4",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/a3.mp3")),
        note: 69,
        color: .systemYellow,
        position: .init(x: 0.8, y: 0.2),
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "D#4",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/d#4.mp3")),
        note: 63,
        color: .systemCyan,
        position: .init(x: 0.1, y: 0.5),
        radius: 0.075,
        type: .Touch
    ),
    SoundButtonModel(
        name: "C#4",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/c#4.mp3")),
        note: 61,
        color: .systemBlue,
        position: .init(x: 0.1, y: 0.7),
        radius: 0.075,
        type: .Touch
    ),
    SoundButtonModel(
        name: "E4",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("piano/e4.mp3")),
        note: 64,
        color: .systemGreen,
        position: .init(x: 0.9, y: 0.6),
        radius: 0.075,
        animation: "Anima1data",
        animationOffset: CGPoint(x: -0.05, y: 0),
        type: .Touch
    ),
]
