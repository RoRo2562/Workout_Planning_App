//
//  ExerciseSet.swift
//  Final-App
//
//  Created by Roro on 7/5/2024.
//

import UIKit
import FirebaseFirestoreSwift

class ExerciseSet: NSObject,Codable {
    @DocumentID var id: String?
    var exerciseName: String?
    var exerciseTarget: String?
    var exerciseDifficulty: String?
    var exerciseEquipment: String?
    var exerciseInstructions: String?
    var setWeight: [Int]?
    var setReps: [Int]?
}
