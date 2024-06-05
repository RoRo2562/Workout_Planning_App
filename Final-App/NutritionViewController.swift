//
//  NutritionViewController.swift
//  Final-App
//
//  Created by Roro on 14/5/2024.
//

import UIKit

class NutritionViewController: UIViewController,FoodAddedDelegate,DatabaseListener {
    var listenerType: ListenerType = .all
    var currentUser = User()
    var mealsToday: Meals?
    weak var databaseController: DatabaseProtocol?
    
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateInFormat = dateFormatter.string(from: todaysDate as Date)

        for meal in currentUser.meals{
            if meal.mealDate == dateInFormat{
                self.mealsToday = meal
            }
        }
        
        if self.mealsToday == nil{
            self.mealsToday = self.databaseController?.addMealToday()
        }
    
        
    }
    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onMealsChange(change: DatabaseChange, todaysMeal: [Meals]) {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateInFormat = dateFormatter.string(from: todaysDate as Date)

        for meal in currentUser.meals{
            if meal.mealDate == dateInFormat{
                self.mealsToday = meal
            }
        }
        if self.mealsToday == nil{
            self.mealsToday = self.databaseController?.addMealToday()
        }
        DispatchQueue.main.async {
            self.mealsTableView.reloadData()
        }
    }
    
    func foodAdded(_ foodItem: FoodSet, _ mealSection: Int) {
        if mealSection == 0{
            self.mealsToday?.breakfast.append(foodItem)
        }
        if mealSection == 1{
            self.mealsToday?.lunch.append(foodItem)
        }
        if mealSection == 2{
            self.mealsToday?.dinner.append(foodItem)
        }
        caloriesConsumed += foodItem.calories ?? 0
        caloriesLabel.text = "calories consumed: " + String(caloriesConsumed) + " calories"
        mealsTableView.reloadData()
    }
    
    
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var mealsTableView: UITableView!
    var currentMeal : Meals?
    //var meals: [[FoodData]] = [[],[],[]]
    var mealAddedTo: Int?
    var caloriesConsumed: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        navigationItem.title = DateInFormat
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        mealsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NutritionViewController : UITableViewDelegate {
    
}

extension NutritionViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return (mealsToday?.breakfast.count ?? 0) + 2
        }
        if section == 1{
            return (mealsToday?.lunch.count ?? 0) + 2
        }
        if section == 2{
            return (mealsToday?.dinner.count ?? 0) + 2
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
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
        
        
        //var content = foodItemCell.defaultContentConfiguration()
        if indexPath.section == 0{
            if indexPath.row == (mealsToday?.breakfast.count ?? 0) + 1 {
                let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
                return addMealCell
            }
            let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath)
            foodItemCell.textLabel?.text = mealsToday?.breakfast[indexPath.row-1].name
            foodItemCell.detailTextLabel?.text = String(mealsToday?.breakfast[indexPath.row-1].calories ?? 0) + " calories"
            return foodItemCell
        }
        if indexPath.section == 1{
            if indexPath.row == (mealsToday?.lunch.count ?? 0) + 1 {
                let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
                return addMealCell
            }
            let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath)
            foodItemCell.textLabel?.text = mealsToday?.lunch[indexPath.row-1].name
            foodItemCell.detailTextLabel?.text = String(mealsToday?.lunch[indexPath.row-1].calories ?? 0) + " calories"
            return foodItemCell
        }
        if indexPath.section == 2{
            if indexPath.row == (mealsToday?.dinner.count ?? 0) + 1 {
                let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
                return addMealCell
            }
            let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath)
            foodItemCell.textLabel?.text = mealsToday?.dinner[indexPath.row-1].name
            foodItemCell.detailTextLabel?.text = String(mealsToday?.dinner[indexPath.row-1].calories ?? 0) + " calories"
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
        if indexPath.section != 3{
            if indexPath.section == 0{
                if indexPath.row == (mealsToday?.breakfast.count ?? 0) + 1{
                    let currentMeal = mealsToday?.breakfast
                    mealAddedTo = indexPath.section
                    performSegue(withIdentifier: "addFoodSegue", sender: Any?.self)
                }
            }
            if indexPath.section == 1{
                if indexPath.row == (mealsToday?.lunch.count ?? 0) + 1{
                    let currentMeal = mealsToday?.lunch
                    mealAddedTo = indexPath.section
                    performSegue(withIdentifier: "addFoodSegue", sender: Any?.self)
                }
            }
            if indexPath.section == 2{
                if indexPath.row == (mealsToday?.dinner.count ?? 0) + 1{
                    let currentMeal = mealsToday?.dinner
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
           destination.mealAddedTo = self.mealAddedTo ?? 0
       }
       
   }
    
    
}
