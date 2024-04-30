//
//  ExercisesData.swift
//  Final-App
//
//  Created by Roro on 30/4/2024.
//

import UIKit

class ExercisesData: NSObject,Decodable {
    var name : String
    var bodyPart : String
    var equipmet : String
    var target : String
    
    private enum CodingKeys: CodingKey {
        case name
        case bodyPart
        case equipmet
        case target

    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.bodyPart = try container.decode(String.self, forKey: .bodyPart)
        self.equipmet = try container.decode(String.self, forKey: .equipmet)
        self.target = try container.decode(String.self, forKey: .target)

    }

}

