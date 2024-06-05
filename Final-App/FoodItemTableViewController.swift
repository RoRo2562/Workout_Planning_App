//
//  FoodItemTableViewController.swift
//  Final-App
//
//  Created by Roro on 5/6/2024.
//

import UIKit

class FoodItemTableViewController: UITableViewController {
    var currentFood: FoodData?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 12
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath)
        cell.textLabel?.text = String(currentFood?.sugar_g ?? 0) + " g"

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
