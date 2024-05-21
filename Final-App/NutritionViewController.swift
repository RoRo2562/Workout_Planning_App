//
//  NutritionViewController.swift
//  Final-App
//
//  Created by Roro on 14/5/2024.
//

import UIKit

class NutritionViewController: UIViewController,FoodAddedDelegate {
    func foodAdded(_ foodItem: FoodData, _ mealSection: Int) {
        meals[mealSection].append(foodItem)
        caloriesConsumed += foodItem.calories
        caloriesLabel.text = "calories consumed: " + String(caloriesConsumed) + " calories"
        mealsTableView.reloadData()
    }
    
    
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var mealsTableView: UITableView!
    var meals: [[FoodData]] = [[],[],[]]
    var mealAddedTo: Int?
    var caloriesConsumed: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)
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
        if section != 3{
            return meals[section].count + 2
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
        if indexPath.row == (meals[indexPath.section].count) + 1 {
            let addMealCell = tableView.dequeueReusableCell(withIdentifier: "addMealCell", for: indexPath)
            return addMealCell
        }
        
        let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath)
        //var content = foodItemCell.defaultContentConfiguration()
        foodItemCell.textLabel?.text = meals[indexPath.section][indexPath.row-1].name
        foodItemCell.detailTextLabel?.text = String(meals[indexPath.section][indexPath.row-1].calories) + " calories"
        return foodItemCell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let number = indexPath.count
        if indexPath.section != 3{
            if indexPath.row == (meals[indexPath.section].count) + 1{
                let currentMeal = self.meals[indexPath.section]
                mealAddedTo = indexPath.section
                performSegue(withIdentifier: "addFoodSegue", sender: Any?.self)
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
