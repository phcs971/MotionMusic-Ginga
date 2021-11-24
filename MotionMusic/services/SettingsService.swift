//
//  settingsService.swift
//  MotionMusic
//
//  Created by Bruno Imai on 24/11/21.
//

import Foundation
import iCarousel

class SettingsService {
    private init() {
        
    }
    static let instance = SettingsService()
    
    let defaults = UserDefaults.standard
    
    func start() {
        
        if !defaults.bool(forKey: "notFirstOpen") {
            defaults.set(false, forKey: "micState")
            defaults.set(true, forKey: "areasState")
            defaults.set(0, forKey: "timerState")
            defaults.set(true, forKey: "cameraState")
            defaults.set(true, forKey: "notFirstOpen")
        }
        
    }
    
    func saveTimerState(timerState : Int) { defaults.set(timerState, forKey: "timerState") }
    func saveAreasState(areasState : Bool) { defaults.set(areasState, forKey: "areasState") }
    func saveMicState(micState : Bool) { defaults.set(micState, forKey: "micState") }
    func saveCameraState(saveCameraState : Bool) { defaults.set(saveCameraState, forKey: "cameraState") }
    
    func loadMicrophone() -> Bool { defaults.bool(forKey: "micState") }
    func loadTimer() -> Int { defaults.integer(forKey: "timerState") }
    func loadAreas() -> Bool { defaults.bool(forKey: "areasState") }
    func loadCamera() -> Bool { defaults.bool(forKey: "cameraState") }
    
    
}
