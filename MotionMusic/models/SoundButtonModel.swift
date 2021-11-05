//
//  SoundButtonModel.swift
//  MotionMusic
//
//  Created by Pedro Henrique Cordeiro Soares on 05/11/21.
//

import UIKit
import CloudKit

enum SoundType: Int {
    case Touch = 0
    case Clap = 1
}

struct SoundButtonModel: Equatable, Identifiable {
    static func == (lhs: SoundButtonModel, rhs: SoundButtonModel) -> Bool { lhs.id == rhs.id }
    
    var id: String = UUID().uuidString
    
    var name: String
    var soundData: Data?
    var filePath: String?
    
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
            "type": type.rawValue
        ])
        return record
    }
    
    static func from(record: CKRecord) -> SoundButtonModel {
        SoundButtonModel(
            id: record.recordID.recordName,
            name: record.value(forKey: "name") as? String ?? "Sem Nome",
            color: .green,
            position: CGPoint(x: record.value(forKey: "x") as! Double, y: record.value(forKey: "y") as! Double),
            radius: record.value(forKey: "radius") as! Double,
            type: SoundType(rawValue: record.value(forKey: "type") as! Int) ?? .Touch
        )
    }
}

#if DEBUG

let mockButtons: [SoundButtonModel] = [
    
]

#endif
