//
//  CoreDatabaseProtocol.swift
//  Final-App
//
//  Created by Roro on 7/6/2024.
//

import Foundation
import CoreData

enum CoreDatabaseChange {
    case add
    case remove
    case update
}

enum CoreListenerType{
    case foods
    case all
}

protocol CoreDataListener: AnyObject{
    var listenerType : ListenerType {get set}
    func onFoodsChange(change: DatabaseChange, foodList : [Food])
}

protocol CoreDatabaseProtocol: AnyObject{
    func coreDataCleanup()
    
    func addListener(listener: CoreDataListener)
    func removeListener(listener: CoreDataListener)
    
    // This function will add the food item to the core data storage
    func addFood(name: String, calories: Float, serving_size_g: Float, fat_total_g: Float,fat_saturated_g: Float, protein_g: Float,
     sodium_mg: Float,
     potassium_mg: Float,
     cholesterol_mg: Float,
     carbohydrates_total_g: Float,
     fiber_g: Float,
     sugar_g: Float)-> Food
    
    
}
