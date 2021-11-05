//
//  VisionServic e.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import Foundation
import Vision

class VisionService {
    private init() {}
    
    static let instance = VisionService()
    
    var requests = [VNRequest]()
    
    func setup(poseHandler: @escaping ((VNHumanBodyPoseObservation) -> Void)) {
        requests = [
            VNDetectHumanBodyPoseRequest(completionHandler: { request, error in
                guard let observations = request.results as? [VNHumanBodyPoseObservation], error != nil else { return printError("Pose Request", error) }
                observations.forEach(poseHandler)
            })
        ]
    }
}
