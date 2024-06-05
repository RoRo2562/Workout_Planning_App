//
//  FoodSet.swift
//  Final-App
//
//  Created by Roro on 5/6/2024.
//

import UIKit

class FoodSet: NSObject,Codable {
    var name: String?
    var calories: Float?
    var serving_size_g: Float?
    var fat_total_g: Float?
    var fat_saturated_g: Float?
    var protein_g: Float?
    var sodium_mg: Float?
    var potassium_mg: Float?
    var cholesterol_mg: Float?
    var carbohydrates_total_g: Float?
    var fiber_g: Float?
    var sugar_g: Float?
}
