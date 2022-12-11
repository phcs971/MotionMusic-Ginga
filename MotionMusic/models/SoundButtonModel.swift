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
import FirebaseFirestore
import FirebaseFirestoreSwift

enum SoundInteractionType: Int, Codable {
    case Touch = 0
    case Toggle = 1
    case Clap = 2
}

struct SoundButtonModel: Equatable, Identifiable, Codable {
    static func == (lhs: SoundButtonModel, rhs: SoundButtonModel) -> Bool { lhs.id == rhs.id }
    
    @DocumentID var id: String? = UUID().uuidString
    
    var name: String
    var file: String
    
    var colorHex: Int
    var color: UIColor { UIColor(rgb: colorHex) }
    
    var position: [String:Double] = ["x": 0, "y": 0]
    
    var radius: Double
    
    var active: Bool = true
    
    var animation: String?
    var animationOffset: [String:Double] = ["x": 0, "y": 0]
    
    var type: SoundInteractionType
}

func mapToPoint(_ map: [String:Double]) -> CGPoint {
    CGPoint(x: map["x"] ?? 0.0, y: map["y"] ?? 0.0)
}

class SoundButtonController: NSObject, Identifiable, AVAudioPlayerDelegate {
    
    static func == (lhs: SoundButtonController, rhs: SoundButtonController) -> Bool { lhs.id == rhs.id }
    
    let soundButton: SoundButtonModel
    
    var id: String { soundButton.id ?? UUID().uuidString }
    var name: String { soundButton.name }
    var type: SoundInteractionType { soundButton.type }
    var color: UIColor { soundButton.color }
    
    var animation: String? { soundButton.animation }
    var animationOffset: CGPoint? { mapToPoint(soundButton.animationOffset) }
    
    var position: CGPoint
    var radius: CGFloat
    
    var player: AVAudioPlayer?
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
            self.position = mapToPoint(soundButton.position)
            self.radius = soundButton.radius
        case .Clap:
            self.position = .zero
            self.radius = 0
        }
        super.init()
        self.downloadAudio(URL(string: soundButton.file))
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
        guard let player = player else { return }
        if player.isPlaying {
            do {
                let newPlayer = try AVAudioPlayer(data: player.data!)
                newPlayer.delegate = self
                duplicatePlayers.append(newPlayer)
                newPlayer.prepareToPlay()
                newPlayer.play()
            } catch {
                printError("NEW PLAYER", error)
            }
        } else {
            player.prepareToPlay()
            player.play()
        }
    }
    
    func downloadAudio(_ url: URL?) {
        guard let url = url else { return }
        do {
            let data = try Data(contentsOf: url)
            self.player = try AVAudioPlayer(data: data)
            self.player?.prepareToPlay()
        } catch {
            printError("DOWNLOAD AUDIO", error)
        }
//        URLSession.shared.downloadTask(with: url) { url, response, error in
//            guard let url = url else { return }
//            self.player = try? AVAudioPlayer(contentsOf: url)
//            self.player?.prepareToPlay()
//        }.resume()
//        task.resume()
//        self.player?.prepareToPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.firstIndex(of: player) {
              duplicatePlayers.remove(at: index)
          }
    }
}

//
//let mockButtons: [SoundButtonModel] = [
//    SoundButtonModel(
//        name: "Clap",
//        file: Bundle.main.resourceURL!.appendingPathComponent("drums/clap_D#1.wav").absoluteString,
//        color: .clear,
//        position: .zero,
//        radius: 0,
//        animation: "burst",
//        type: .Clap
//    ),
//    SoundButtonModel(
//        name: "Open",
//        file: Bundle.main.resourceURL!.appendingPathComponent("drums/open_hi_hat_A#1.wav").absoluteString,
//        color: .systemYellow,
//        position: .init(x: 0.2, y: 0.2),
//        radius: 0.1,
//        type: .Touch
//    ),
//    SoundButtonModel(
//        name: "Bass",
//        file: Bundle.main.resourceURL!.appendingPathComponent("drums/bass_drum_C1.wav").absoluteString,
//        color: 0x00FF00,
//        position: .init(x: 0.5, y: 0.9),
//        radius: 0.1,
//        type: .Touch
//    ),
//]
//
//
//let mockButtons2: [SoundButtonModel] = [
//    SoundButtonModel(
//        name: "Bass",
//        file: Bundle.main.resourceURL!.appendingPathComponent("drums/bass_drum_C1.wav").absoluteString,
//        color: .clear,
//        position: .zero,
//        radius: 0,
//        animation: "burst",
//        type: .Clap
//    ),
//    SoundButtonModel(
//        name: "Open",
//        file: Bundle.main.resourceURL!.appendingPathComponent("drums/open_hi_hat_A#1.wav").absoluteString,
//        color: 0x0000FF,
//        position: .init(x: 0.6, y: 0.2),
//        radius: 0.1,
//        type: .Touch
//    ),
//    SoundButtonModel(
//        name: "Clap",
//        file: Bundle.main.resourceURL!.appendingPathComponent("drums/clap_D#1.wav").absoluteString,
//        color: 0xFF0000,
//        position: .init(x: 0.1, y: 0.9),
//        radius: 0.1,
//        type: .Touch
//    ),
//]

let drumsSet: [SoundButtonModel] = [
    SoundButtonModel(
        name: "Clap",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/clap_D#1.wav").absoluteString,
        colorHex: 0xFFFFFF,
        position: ["x": 0, "y": 0],
        radius: 0,
        animation: "burst",
        type: .Clap
    ),
    SoundButtonModel(
        name: "Bass",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/bass_drum_C1.wav").absoluteString,
        colorHex: 0x00FF00,
        position: ["x": 0.5, "y": 0.88],
        radius: 0.12,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Snare",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/snare_D1.wav").absoluteString,
        colorHex: 0xDA8FFF,
        position: ["x": 0.2, "y": 0.9],
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Low Tom",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/lo_tom_F1.wav").absoluteString,
        colorHex: 0x70D7FF,
        position: ["x": 0.8, "y": 0.9],
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Open Hat",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/open_hi_hat_A#1.wav").absoluteString,
        colorHex: 0xFFB340,
        position: ["x": 0.15, "y": 0.6],
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Closed Hat",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/closed_hi_hat_F#1.wav").absoluteString,
        colorHex: 0xFF0000,
        position: ["x": 0.85, "y": 0.6],
        radius: 0.1,
        type: .Touch
    ),
    SoundButtonModel(
        name: "High Tom",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/hi_tom_D2.wav").absoluteString,
        colorHex: 0x7D7AFF,
        position: ["x": 0.3, "y": 0.2],
        radius: 0.075,
        type: .Touch
    ),
    SoundButtonModel(
        name: "Mid Tom",
        file: Bundle.main.resourceURL!.appendingPathComponent("drums/mid_tom_B1.wav").absoluteString,
        colorHex: 0x0000FF,
        position: ["x": 0.7, "y": 0.2],
        radius: 0.075,
        type: .Touch
    ),
]


let alorsOnDanse: [SoundButtonModel] = [
    SoundButtonModel(
        name: "BoomClap",
        file: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/LoopBoomClapC1.mp3").absoluteString,
        colorHex: 0xFF0000,
        position: ["x": 0.25, "y": 0.2],
        radius: 0.1,
        animation: "loopBall",
        type: .Toggle
    ),
    SoundButtonModel(
        name: "Melodia",
        file: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/LoopMelodiaFundoD1.mp3").absoluteString,
        colorHex: 0xFFB340,
        position: ["x": 0.75, "y": 0.2],
        radius: 0.1,
        animation: "loopStar",
        type: .Toggle
    ),
    SoundButtonModel(
        name: "D#3",
        file: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxD#3.mp3").absoluteString,
        colorHex: 0x00FF00,
        position: ["x": 0.1, "y": 0.65],
        radius: 0.075,
        animation: "stars",
        type: .Touch
    ),
    SoundButtonModel(
        name: "C#3",
        file: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxC#3.mp3").absoluteString,
        colorHex: 0x00FF00,
        position: ["x": 0.9, "y": 0.65],
        radius: 0.075,
        animation: "burst",
        type: .Touch
    ),
    SoundButtonModel(
        name: "E3",
        file: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxE3.mp3").absoluteString,
        colorHex: 0x00FF00,
        position: ["x": 0.1, "y": 0.4],
        radius: 0.075,
        animation: "explosion",
        type: .Touch
    ),
    SoundButtonModel(
        name: "F#3",
        file: Bundle.main.resourceURL!.appendingPathComponent("Alors On Danse/SaxF#3.mp3").absoluteString,
        colorHex: 0x00FF00,
        position: ["x": 0.9, "y": 0.4],
        radius: 0.075,
        animation: "oneStar",
        type: .Touch
    ),
]
