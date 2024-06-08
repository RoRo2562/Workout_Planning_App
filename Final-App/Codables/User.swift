//
//  User.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit
import FirebaseFirestoreSwift
enum CodingKeys: String, Codable{
    case id
    case name
    case email
    case userId
    case workouts
    case meals

}
class User: NSObject,Codable {
    @DocumentID var id: String?
    var userId : String?
    var email: String?
    var name: String?
    var workouts: [Workout] = []
    var meals: [Meals] = []
   // var workout: Workout?
}
