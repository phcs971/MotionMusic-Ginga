//
//  SoundButtonModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import CloudKit
import AVFoundation

enum SoundType: Int {
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
    
    var type: SoundType
    
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
        ])
        return record
    }
    
    static func from(record: CKRecord) -> SoundButtonModel {
        SoundButtonModel(
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
            type: SoundType(rawValue: record.value(forKey: "type") as! Int) ?? .Touch
        )
    }
}

class SoundButtonController: Equatable, Identifiable {
    static func == (lhs: SoundButtonController, rhs: SoundButtonController) -> Bool { lhs.id == rhs.id }
    
    let soundButton: SoundButtonModel
    
    var id: String { soundButton.id }
    var name: String { soundButton.name }
    var type: SoundType { soundButton.type }
    var color: UIColor { soundButton.color }
    var note: Int { soundButton.note }
    
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

#if DEBUG

let mockButtons: [SoundButtonModel] = [
    SoundButtonModel(
        name: "Clap",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("clap_D#1.wav")),
        note: 27,
        color: .clear,
        position: .zero,
        radius: 0,
        type: .Clap
    ),
    SoundButtonModel(
        name: "Open",
        soundFile: CKAsset(fileURL: Bundle.main.resourceURL!.appendingPathComponent("open_hi_hat_A#1.wav")),
        note: 34,
        color: .systemYellow,
        position: .init(x: 0.2, y: 0.2),
        radius: 0.1,
        type: .Touch
    ),
]

#endif
