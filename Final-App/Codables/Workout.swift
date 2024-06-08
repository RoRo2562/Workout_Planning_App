//
//  Workout.swift
//  Final-App
//
//  Created by Roro on 7/5/2024.
//

import UIKit
import FirebaseFirestoreSwift

class Workout: NSObject,Codable {
    var id: String?
    var workoutName: String?
    var userId: String?
    var exerciseSets: [ExerciseSet] = []
   
}
