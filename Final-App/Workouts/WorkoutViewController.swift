//
//  WorkoutViewController.swift
//  Final-App
//
//  Created by Roro on 19/5/2024.
//

import UIKit

// This is a view controller that displays the data of a current workout
class WorkoutViewController: UIViewController, cellTextFieldDelegate {
    func updateExerciseSet(with kgText: Int?, repsText: Int?, for cell: ExerciseSetTableViewCell) {
        
    }
    
    @IBOutlet weak var workoutTableView: UITableView!
    
    var currentWorkout: Workout? // The current workout
    
    weak var firebaseController: FirebaseController?
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentWorkout else{
            navigationItem.title = "NO WORKOUT SELECTED"
            return
        }
        navigationItem.title = currentWorkout.workoutName // Sets the title as the workouts name
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController as? FirebaseController
        
        // Register the custom cells I created
        workoutTableView.register(UINib(nibName: "ExerciseSetTableViewCell", bundle: nil),forCellReuseIdentifier: ExerciseSetTableViewCell.indentifier)
        workoutTableView.register(UINib(nibName: "ExerciseSetTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ExerciseSetTitleTableViewCell.identifier)
        
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        workoutTableView.reloadData() // Load the data into the table

    }
    

}


extension WorkoutViewController : UITableViewDelegate {
    
}

extension WorkoutViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentWorkout?.exerciseSets.count ?? 1 // The number of sections is the number of different workouts in the
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (currentWorkout?.exerciseSets[section].setReps?.count ?? 0) + 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1{ // I want the second row to display my column titles which is my custom cell
            let titleCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTitleTableViewCell.identifier, for: indexPath) as! ExerciseSetTitleTableViewCell
            return titleCell
        }
        if indexPath.row == (currentWorkout?.exerciseSets[indexPath.section].setReps?.count ?? 0) + 2{
            let addSetCell = tableView.dequeueReusableCell(withIdentifier: "addSetCell", for: indexPath)
            return addSetCell
        }
        
        if indexPath.row > 1{ // For every row thats not the first two rows and not the last row, display the set data stored in the workout
            let setCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTableViewCell.indentifier, for: indexPath) as! ExerciseSetTableViewCell
            setCell.configure(with: indexPath.row-1, delegate: self)
            print(indexPath.row)
            setCell.repsTextField.text = String(currentWorkout?.exerciseSets[indexPath.section].setReps?[indexPath.row - 2] ?? 0) 
            // Set the reps from the workout
            setCell.kgTextField.text = String(currentWorkout?.exerciseSets[indexPath.section].setWeight?[indexPath.row - 2] ?? 0)
            // Set the weight from the workout
            return setCell
        }
        
        
        let exerciseTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        exerciseTitleCell.textLabel?.text = currentWorkout?.exerciseSets[indexPath.section].exerciseName // Display the exercise name as the first row in each section
        return exerciseTitleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // Set the cell height 
    }

    
}
