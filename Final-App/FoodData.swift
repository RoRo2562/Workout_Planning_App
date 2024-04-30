//
//  FoodData.swift
//  Final-App
//
//  Created by Roro on 30/4/2024.
//

import UIKit

class FoodData: NSObject,Decodable {
    var name: String
    var calories: Float
    
    private enum CodingKeys : CodingKey{
        case name
        case calories
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.calories = try container.decode(Float.self, forKey: .calories)
    }
}
