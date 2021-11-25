//
//  settingsService.swift
//  MotionMusic
//
//  Created by Bruno Imai on 24/11/21.
//

import Foundation
import iCarousel

let DEBUG_MODE = false
#if targetEnvironment(simulator)
let IS_SIMULATOR = true
#else
let IS_SIMULATOR = false
#endif
let FORCE_ONBOARDING = true

class SettingsService {
    private init() { }
    
    static let instance = SettingsService()
    
    let defaults = UserDefaults.standard
    
    var firstOpen = false
    
    var effectId: String?
    var genreId: String?
    var musicId: String?
    
    var configuring = false
    
    func start() {
        firstOpen = FORCE_ONBOARDING || !defaults.bool(forKey: "notFirstOpen")
        if firstOpen {
            defaults.set(true, forKey: "areasState")
            defaults.set(0, forKey: "timerState")
            defaults.set(false, forKey: "micState")
            defaults.set(true, forKey: "cameraState")
            defaults.set(true, forKey: "notFirstOpen")
        }
        self.load()
    }
    
    func load() {
        effectId = defaults.string(forKey: "effect")
        genreId = defaults.string(forKey: "genre")
        musicId = defaults.string(forKey: "music")
    }
    
    func updateMotionMusic() {
        
    }
    
    func saveAreasState(areasState : Bool) { defaults.set(areasState, forKey: "areasState") }
    func saveTimerState(timerState : Int) { defaults.set(timerState, forKey: "timerState") }
    func saveMicState(micState : Bool) { defaults.set(micState, forKey: "micState") }
    func saveCameraState(saveCameraState : Bool) { defaults.set(saveCameraState, forKey: "cameraState") }
    
    func saveEffect(_ id: String) { effectId = id; defaults.set(id, forKey: "effect") }
    func saveGenre(_ id: String) { genreId = id; defaults.set(id, forKey: "genre") }
    func saveMusic(_ id: String) { musicId = id; defaults.set(id, forKey: "music") }
    
    func loadAreas() -> Bool { defaults.bool(forKey: "areasState") }
    func loadTimer() -> Int { defaults.integer(forKey: "timerState") }
    func loadMicrophone() -> Bool { defaults.bool(forKey: "micState") }
    func loadCamera() -> Bool { defaults.bool(forKey: "cameraState") }
    
    
}
