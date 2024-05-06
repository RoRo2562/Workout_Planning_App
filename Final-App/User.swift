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
}
class User: NSObject,Codable {
    @DocumentID var id: String?
    var userId : String?
    var email: String?
    var name: String?
   // var workout: Workout?
}
