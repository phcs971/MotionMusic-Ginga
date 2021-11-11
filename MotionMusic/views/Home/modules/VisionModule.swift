//
//  VisionModule.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 11/11/21.
//

import UIKit
import Vision
import AVFoundation

extension HomeViewController {
    
    func setupVision() {
        let bodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)
        
        let handRequest = VNDetectHumanHandPoseRequest(completionHandler: handPoseHandler)
        handRequest.maximumHandCount = 2
        
        self.requests = [
            bodyRequest,
            handRequest
        ]
    }
    
    
    func handPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanHandPoseObservation], error == nil else { return printError("Hand Pose Request", error) }
        
        observations.forEach { processHandPose($0) }
    }
    
    func processHandPose(_ observation: VNHumanHandPoseObservation) {
        guard let recognizedPoints = try? observation.recognizedPoints(.all) else { return }
        
        
        var percentPoints = [CGPoint]()
        var imagePoints = [VNHumanHandPoseObservation.JointName : CGPoint]()
        
        let joints: [VNHumanHandPoseObservation.JointName] = [
            .indexTip, .indexMCP, .ringTip, .ringMCP, .thumbTip, .thumbCMC, .middleTip, .middleMCP, .littleTip, .littleMCP, .wrist
        ]
        
        recognizedPoints.forEach { joint, point in
            guard point.confidence > 0.5, joints.contains(joint) else { return }
            let normalized = VNImagePointForNormalizedPoint(point.location, Int(bufferSize.width), Int(bufferSize.height))
            imagePoints[joint] = normalized
            percentPoints.append(point.location)
        }
        
        points.append(PointGroupModel(
            points: imagePoints,
            percentPoints: percentPoints,
            radius: 8,
            color: UIColor.green.cgColor
        ))
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanBodyPoseObservation], error == nil else { return printError("Body Pose Request", error) }
        
        observations.forEach { processBodyPose($0) }
    }
    
    func processBodyPose(_ observation: VNHumanBodyPoseObservation) {
        guard let recognizedPoints = try? observation.recognizedPoints(.all) else { return }
        
        var percentPoints = [CGPoint]()
        var imagePoints = [VNHumanBodyPoseObservation.JointName : CGPoint]()
        
        let joints: [VNHumanBodyPoseObservation.JointName] = [
            .leftAnkle,
            .leftElbow,
            .leftHip,
            .leftKnee,
            .rightAnkle,
            .rightElbow,
            .rightHip,
            .rightKnee,
            .root,
            .leftEar,
            .rightEar,
            .nose,
            
        ]
        
        recognizedPoints.forEach { joint, point in
            guard point.confidence > 0.5, joints.contains(joint) else { return }
            let normalized = VNImagePointForNormalizedPoint(point.location, Int(bufferSize.width), Int(bufferSize.height))
            imagePoints[joint] = normalized
            percentPoints.append(point.location)
        }
        
        if let leftHand = recognizedPoints[.leftWrist], let rightHand = recognizedPoints[.rightWrist] {
            if leftHand.confidence > 0.5 && rightHand.confidence > 0.5 {
                let lH = VNImagePointForNormalizedPoint(leftHand.location, Int(bufferSize.width), Int(bufferSize.height))
                let rH = VNImagePointForNormalizedPoint(rightHand.location, Int(bufferSize.width), Int(bufferSize.height))
                let distance = lH.distance(to: rH)
                if distance < 30 {
                    if !self.isClapping {
                        self.isClapping = true
                        self.onClap(point: leftHand.location.midPoint(to: rightHand.location))
                    }
                } else {
                    self.isClapping = false
                }
            }
        }
        
        points.append(PointGroupModel(
            points: imagePoints,
            percentPoints: percentPoints,
            radius: 12,
            color: UIColor.blue.cgColor
        ))
    }
    
    func drawPoints() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionLayer.sublayers = nil
        
        points.forEach { group in
            self.draw(points: group.pointArray, radius: group.radius, color: group.color)
        }
        
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func draw(points: [CGPoint], radius: CGFloat, color: CGColor) {
        for point in points {
            let layer = CAShapeLayer()
            layer.position = CGPoint(x: point.x, y: point.y)
            layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: radius, height: radius), cornerRadius: radius / 2).cgPath
            layer.fillColor = color
            self.detectionLayer.addSublayer(layer)
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) { }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if DEBUG_MODE {
            let diff = self.lastFrame.distance(to: Date())
            if (diff != 0) {
                DispatchQueue.main.async {
                    let fps_value = Int((1 / diff).rounded())
                    
                    self.FpsLabel.text = "\(fps_value) FPS"
                    self.lastFrame = Date()
                }
            }
        }
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return printError("Buffer is Nil") }
        
        let exif = exifOrientationFromDeviceOrientation()
        let imgRequestHandler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: exif, options: [:])
        do {
            points = []
            try imgRequestHandler.perform(self.requests)
            DispatchQueue.main.async {
                var points = [CGPoint]()
                self.points.forEach { points.append(contentsOf: $0.percentPoints) }
                self.checkAllPoints(points:  points)
                if DEBUG_MODE { self.drawPoints() }
            }
        } catch {
            printError("Vision Handler", error)
        }
    }
}
