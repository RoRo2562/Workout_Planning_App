//
//  ExerciseTableViewController.swift
//  Final-App
//
//  Created by Roro on 21/5/2024.
//

import UIKit
// View controller for the view displaying the data of an exercise
class ExerciseTableViewController: UITableViewController {
    var currentExercise: ExercisesData?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = currentExercise?.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // There are 5 attributes of exercise data
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 piece of data per attribute
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Sets the title based on the attribute for each section
        if section == 0{
            return "Name"
        }
        if section == 1{
            return "Muscle"
        }
        if section == 2{
            return "Equipment"
        }
        if section == 3{
            return "Difficulty"
        }
        if section == 4{
            return "Instructions"
        }
        return ""
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  This loads all the data into each section
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = currentExercise?.name
            return cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = currentExercise?.muscle
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = currentExercise?.equipment
            return cell
        }
        if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
            cell.textLabel?.text = currentExercise?.difficulty
            return cell
        }
        
        // Allows the instructions to take up more than line in the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
        cell.textLabel?.text = currentExercise?.instructions
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0

        return cell
    }
    

}
