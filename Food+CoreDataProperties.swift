//
//  Food+CoreDataProperties.swift
//  Final-App
//
//  Created by Roro on 7/6/2024.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var name: String?
    @NSManaged public var calories: Float
    @NSManaged public var serving_size_g: Float
    @NSManaged public var fat_total_g: Float
    @NSManaged public var fat_saturated_g: Float
    @NSManaged public var protein_g: Float
    @NSManaged public var sodium_mg: Float
    @NSManaged public var potassium_mg: Float
    @NSManaged public var cholesterol_mg: Float
    @NSManaged public var carbohydrates_total_g: Float
    @NSManaged public var fiber_g: Float
    @NSManaged public var sugar_g: Float

}

extension Food : Identifiable {

}
