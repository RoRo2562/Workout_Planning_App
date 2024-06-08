//
//  CoreDataController.swift
//  Final-App
//
//  Created by Roro on 7/6/2024.
//

import UIKit
import CoreData

class CoreDataController: NSObject,CoreDatabaseProtocol{
    
    var listeners = MulticastDelegate<CoreDataListener>()
    var persistentContainer: NSPersistentContainer
    
    func coreDataCleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: any CoreDataListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .all {
            listener.onFoodsChange(change: .update, foodList: fetchAllFoods())
        }
    }
    
    func removeListener(listener: any CoreDataListener) {
        listeners.removeDelegate(listener)
    }
    
    func addFood(name: String, calories: Float, serving_size_g: Float, fat_total_g: Float, fat_saturated_g: Float, protein_g: Float, sodium_mg: Float, potassium_mg: Float, cholesterol_mg: Float, carbohydrates_total_g: Float, fiber_g: Float, sugar_g: Float) -> Food {
        
        let food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: persistentContainer.viewContext) as! Food
        // Set all the attributes of the food item
        food.name = name
        food.calories = calories
        food.serving_size_g = serving_size_g
        food.fat_total_g = fat_total_g
        food.fat_saturated_g = fat_saturated_g
        food.protein_g = protein_g
        food.sodium_mg = sodium_mg
        food.potassium_mg = potassium_mg
        food.cholesterol_mg = cholesterol_mg
        food.carbohydrates_total_g = carbohydrates_total_g
        food.fiber_g = fiber_g
        food.sugar_g = sugar_g
        
        
        return food
    }
    
    func fetchAllFoods() -> [Food]{
        var foods = [Food]()
        
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        
        do{
            try foods = persistentContainer.viewContext.fetch(request)
        } catch{
            print("Fetch Request failed with error: \(error)")
        }
        
        return foods
    }
 
    
    override init(){
            persistentContainer = NSPersistentContainer(name: "FinalApp-DataModel")
            persistentContainer.loadPersistentStores() { (description, error ) in
                if let error = error {
                    fatalError("Failed to load Core Data Stack with error: \(error)")
                }
        }
    }
}


