//
//  Meals.swift
//  Final-App
//
//  Created by Roro on 5/6/2024.
//

import UIKit

class Meals: NSObject,Codable {
    var id: String?
    var mealDate: String?
    var userId: String?
    var breakfast: [FoodSet] = []
    var lunch: [FoodSet] = []
    var dinner: [FoodSet] = []
}
