//
//  NutritionViewController.swift
//  Final-App
//
//  Created by Roro on 14/5/2024.
//

import UIKit

// This class displays the nutrition data displaying the users meals for the date selected
class NutritionViewController: UIViewController,FoodAddedDelegate,DatabaseListener {
    var listenerType: ListenerType = .all
    var currentUser = User()
    var currentMeal: Meals? // Meal data for the current date selected
    weak var databaseController: DatabaseProtocol?
    weak var firebaseController: FirebaseController?
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var mealsTableView: UITableView!
    var mealAddedTo: Int?
    var caloriesConsumed: Float = 0
    
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
        
    }
    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onMealsChange(change: DatabaseChange, meals: [Meals]) {

        DispatchQueue.main.async {
            self.mealsTableView.reloadData()
        }
    }
    
    func foodAdded(_ foodItem: FoodSet, _ mealSection: Int) {
        if mealSection == 0{ // If the meal we want to add to is breakfast
            if let mealToAddTo = self.currentMeal{
                self.currentMeal?.breakfast.append(foodItem)
                // Update the database
                self.databaseController?.addFoodToMeal(mealToAddTo: mealToAddTo, foodItem: foodItem, mealTime: "breakfast")
            }
        }
        if mealSection == 1{ // If the meal to add to is lunch
            if let mealToAddTo = self.currentMeal{
                self.currentMeal?.lunch.append(foodItem)
                // Update the database
                self.databaseController?.addFoodToMeal(mealToAddTo: mealToAddTo, foodItem: foodItem, mealTime: "lunch")
            }
        }
        if mealSection == 2{ // If the meal to add to is dinner
            if let mealToAddTo = self.currentMeal{
                self.currentMeal?.dinner.append(foodItem)
                // Update the database
                self.databaseController?.addFoodToMeal(mealToAddTo: mealToAddTo, foodItem: foodItem, mealTime: "dinner")
            }
        }
        caloriesConsumed += foodItem.calories ?? 0
        caloriesLabel.text = "calories consumed: " + String(caloriesConsumed) + " calories" // Update how many calories were consumed today
        mealsTableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        navigationItem.title = currentMeal?.mealDate
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        mealsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    // Remove the listeners when the view dissappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    

}

extension NutritionViewController : UITableViewDelegate {
    
}

extension NutritionViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Breakfast lunch and dinner
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return (currentMeal?.breakfast.count ?? 0) + 2 // 2 because we have breakfast title and add to meal row
        }
        if section == 1{
            return (currentMeal?.lunch.count ?? 0) + 2 // 2 because we have lunch title and add to meal row
        }
        if section == 2{
            return (currentMeal?.dinner.count ?? 0) + 2 // 2 because we have dinner title and add to meal row
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{ // If first row of the section set the meal time titles
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
            if indexPath.section == 0{
                titleCell.textLabel?.text = "Breakfast"
            }
            if indexPath.section == 1{
                titleCell.textLabel?.text = "Lunch"
            }
            if indexPath.section == 2{
                titleCell.textLabel?.text = "Dinner"
            }
            return titleCell
        }
        
        
        if indexPath.section == 0{
            if indexPath.row == (currentMeal?.breakfast.count ?? 0) + 1 { // Last row of the section is the add meal row
                let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
                return addMealCell
            }
            let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath) // The rest are food names and calories
            foodItemCell.textLabel?.text = currentMeal?.breakfast[indexPath.row-1].name
            foodItemCell.detailTextLabel?.text = String(currentMeal?.breakfast[indexPath.row-1].calories ?? 0) + " calories"
            return foodItemCell
        }
        if indexPath.section == 1{
            if indexPath.row == (currentMeal?.lunch.count ?? 0) + 1 { // Last row of the section is the add meal row
                let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
                return addMealCell
            }
            let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath) // The rest are food names and calories
            foodItemCell.textLabel?.text = currentMeal?.lunch[indexPath.row-1].name
            foodItemCell.detailTextLabel?.text = String(currentMeal?.lunch[indexPath.row-1].calories ?? 0) + " calories"
            return foodItemCell
        }
        if indexPath.section == 2{
            if indexPath.row == (currentMeal?.dinner.count ?? 0) + 1 { // Last row of the section is the add meal row
                let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
                return addMealCell
            }
            let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath) // The rest are food names and calories
            foodItemCell.textLabel?.text = currentMeal?.dinner[indexPath.row-1].name
            foodItemCell.detailTextLabel?.text = String(currentMeal?.dinner[indexPath.row-1].calories ?? 0) + " calories"
            return foodItemCell
        }
        // This is just to satisfy the return, never gets reached
        let titleCell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
        return titleCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 3{ // If the row is the last row in each section this is the add food to meal row
            if indexPath.section == 0{
                if indexPath.row == (currentMeal?.breakfast.count ?? 0) + 1{
                    _ = currentMeal?.breakfast
                    mealAddedTo = indexPath.section
                    performSegue(withIdentifier: "addFoodSegue", sender: Any?.self)
                }
            }
            if indexPath.section == 1{
                if indexPath.row == (currentMeal?.lunch.count ?? 0) + 1{
                    _ = currentMeal?.lunch
                    mealAddedTo = indexPath.section
                    performSegue(withIdentifier: "addFoodSegue", sender: Any?.self)
                }
            }
            if indexPath.section == 2{
                if indexPath.row == (currentMeal?.dinner.count ?? 0) + 1{
                    _ = currentMeal?.dinner
                    mealAddedTo = indexPath.section
                    performSegue(withIdentifier: "addFoodSegue", sender: Any?.self)
                }
            }
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "addFoodSegue"{
           let destination = segue.destination as! FoodTableViewController
           destination.delegate = self
           destination.mealAddedTo = self.mealAddedTo ?? 0 // Choose which meal time the meal is being added to
       }
       
   }
    
    
    
    
}
