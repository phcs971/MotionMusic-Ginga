//
//  functions.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit

func printError(_ description: String? = nil, _ error: Error? = nil) {
    print("\n\n")
    print("ERROR: \(description ?? "")")
    if let error = error { print(error.localizedDescription) }
    print("\n\n")
}

func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
    let curDeviceOrientation = UIDevice.current.orientation
    let exifOrientation: CGImagePropertyOrientation
    
    switch curDeviceOrientation {
    case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
        exifOrientation = .left
    case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
        exifOrientation = .upMirrored
    case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
        exifOrientation = .down
    case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
        exifOrientation = .up
    default:
        exifOrientation = .up
    }
    return exifOrientation
}

func getURL(for directory: FileManager.SearchPathDirectory, fileExtension: String) -> URL {
    FileManager.default.urls(for: directory, in: .userDomainMask).first!
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension(fileExtension)
}

func getTempURL(fileExtension: String) -> URL {
    URL(
        fileURLWithPath: (NSTemporaryDirectory() as NSString)
            .appendingPathComponent(UUID().uuidString + ".\(fileExtension)")
    )
}
