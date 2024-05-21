//
//  ExerciseSetData.swift
//  Final-App
//
//  Created by Roro on 21/5/2024.
//

import UIKit

class ExerciseSetData: NSObject,Decodable {
    var exerciseName: String?
    var exerciseTarget: String?
    var exerciseDifficulty: String?
    var exerciseEquipment: String?
    var exerciseInstructions: String?
    var setWeight: [Int]?
    var setReps: [Int]?
    
    private enum CodingKeys: CodingKey{
        case exerciseName
        case exerciseTarget
        case exerciseDifficulty
        case exerciseEquipment
        case exerciseInstructions
        case setWeight
        case setReps
    }
    
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exerciseName = try container.decode(String.self, forKey: .exerciseName)
        self.exerciseTarget = try container.decode(String.self, forKey: .exerciseTarget)
        self.exerciseDifficulty = try container.decode(String.self, forKey: .exerciseDifficulty)
        self.exerciseEquipment = try container.decode(String.self, forKey: .exerciseEquipment)
        self.exerciseInstructions = try container.decode(String.self, forKey: .exerciseInstructions)
        self.setWeight = try container.decode([Int].self, forKey: .setWeight)
        self.setReps = try container.decode([Int].self, forKey: .setReps)

    }
}
