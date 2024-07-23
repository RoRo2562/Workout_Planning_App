//
//  FoodItemTableViewController.swift
//  Final-App
//
//  Created by Roro on 5/6/2024.
//

import UIKit

// This view controller displays the data of the food item when we click on the info from the food table view controller
class FoodItemTableViewController: UITableViewController {
    var currentFood: Food?
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBAction func viewChartButton(_ sender: Any) {
        performSegue(withIdentifier: "viewChartSegue", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currentFood?.name
        navigationItem.rightBarButtonItem = rightButton

    }

    
    // Number of attributes of food
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Sets the title of the section based on the number
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Name"
        }
        if section == 1{
            return "Calories"
        }
        if section == 2{
            return "Serving Size"
        }
        if section == 3{
            return "Total Fat"
        }
        if section == 4{
            return "Saturated Fat"
        }
        if section == 5{
            return "Protein"
        }
        if section == 6{
            return "Sodium"
        }
        if section == 7{
            return "Potassium"
        }
        if section == 8{
            return "Cholesterol"
        }
        if section == 9{
            return "Total Carbohydrates"
        }
        if section == 10{
            return "Fiber"
        }
        if section == 11{
            return "Sugar"
        }
        return ""
    }
    
    // Loads the data of each attribute into each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = currentFood?.name
            return cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.calories ?? 0)
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.serving_size_g ?? 0) + " g"
            return cell
        }
        if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.fat_total_g ?? 0) + " g"
            return cell
        }
        if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.fat_saturated_g ?? 0) + " g"
            return cell
        }
        if indexPath.section == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.protein_g ?? 0) + " g"
            return cell
        }
        if indexPath.section == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.sodium_mg ?? 0) + " mg"
            return cell
        }
        if indexPath.section == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.potassium_mg ?? 0) + " mg"
            return cell
        }
        if indexPath.section == 8{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.cholesterol_mg ?? 0) + " mg"
            return cell
        }
        if indexPath.section == 9{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.carbohydrates_total_g ?? 0) + " g"
            return cell
        }
        if indexPath.section == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.fiber_g ?? 0) + " g"
            return cell
        }
        
        if indexPath.section == 11{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = String(currentFood?.sugar_g ?? 0) + " g"

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "viewChartSegue"{
           let destination = segue.destination as! FoodPieChartViewController
           destination.currentFood = self.currentFood // Passes the food into the segue so the chart receives the food data
       }
       
   }
    
    

}
