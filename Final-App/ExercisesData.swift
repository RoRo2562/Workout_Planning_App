//
//  ExercisesData.swift
//  Final-App
//
//  Created by Roro on 30/4/2024.
//

import UIKit

class ExercisesData: NSObject,Decodable {
    var name : String
    var muscle : String
    var equipment : String
    var difficulty : String
    
    private enum CodingKeys: CodingKey {
        case name
        case muscle
        case equipment
        case difficulty

    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.muscle = try container.decode(String.self, forKey: .muscle)
        self.equipment = try container.decode(String.self, forKey: .equipment)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)

    }

}

