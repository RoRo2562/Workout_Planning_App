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
    var serving_size_g: Float
    var fat_total_g: Float
    var fat_saturated_g: Float
    var protein_g: Float
    var sodium_mg: Float
    var potassium_mg: Float
    var cholesterol_mg: Float
    var carbohydrates_total_g: Float
    var fiber_g: Float
    var sugar_g: Float
    
    private enum CodingKeys : CodingKey{
        case name
        case calories
        case serving_size_g
        case fat_total_g
        case fat_saturated_g
        case protein_g
        case sodium_mg
        case potassium_mg
        case cholesterol_mg
        case carbohydrates_total_g
        case fiber_g
        case sugar_g
        
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.calories = try container.decode(Float.self, forKey: .calories)
        self.serving_size_g = try container.decode(Float.self, forKey: .serving_size_g)
        self.fat_total_g = try container.decode(Float.self, forKey: .fat_total_g)
        self.fat_saturated_g = try container.decode(Float.self, forKey: .fat_saturated_g)
        self.protein_g = try container.decode(Float.self, forKey: .protein_g)
        self.sodium_mg = try container.decode(Float.self, forKey: .sodium_mg)
        self.potassium_mg = try container.decode(Float.self, forKey: .potassium_mg)
        self.cholesterol_mg = try container.decode(Float.self, forKey: .cholesterol_mg)
        self.carbohydrates_total_g = try container.decode(Float.self, forKey: .carbohydrates_total_g)
        self.fiber_g = try container.decode(Float.self, forKey: .fiber_g)
        self.sugar_g = try container.decode(Float.self, forKey: .sugar_g)
    }
}
