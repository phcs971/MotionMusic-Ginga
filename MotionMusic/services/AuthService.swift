//
//  AuthService.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 02/12/21.
//

import Foundation
import Firebase

class AuthService {
    private init() {}
    
    static let instance = AuthService()
    
    let auth = Auth.auth()
    
    func signInAnonymously() {
        auth.signInAnonymously { result, error in
            guard let result = result, error == nil else { return printError("SIGN IN", error) }
            print("Logged In:", result.user.uid)
            DatabaseService.instance.populate()
        }
    }
    
    var userId: String? { auth.currentUser?.uid }
}
