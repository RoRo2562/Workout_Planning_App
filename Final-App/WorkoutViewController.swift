//
//  WorkoutViewController.swift
//  Final-App
//
//  Created by Roro on 19/5/2024.
//

import UIKit

class WorkoutViewController: UIViewController, cellTextFieldDelegate {
    func updateExerciseSet(with kgText: Int?, repsText: Int?, for cell: ExerciseSetTableViewCell) {
        
    }
    
    @IBOutlet weak var workoutTableView: UITableView!
    var currentWorkout: Workout?
    
    weak var firebaseController: FirebaseController?
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentWorkout else{
            navigationItem.title = "NO WORKOUT SELECTED"
            return
        }
        navigationItem.title = currentWorkout.workoutName
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        let exerciseSets = currentWorkout.exerciseSets[0] 
        databaseController = appDelegate?.databaseController as? FirebaseController
        
        workoutTableView.register(UINib(nibName: "ExerciseSetTableViewCell", bundle: nil),forCellReuseIdentifier: ExerciseSetTableViewCell.indentifier)
        workoutTableView.register(UINib(nibName: "ExerciseSetTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ExerciseSetTitleTableViewCell.identifier)
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        workoutTableView.reloadData()

        
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


extension WorkoutViewController : UITableViewDelegate {
    
}

extension WorkoutViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentWorkout?.exerciseSets.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (currentWorkout?.exerciseSets[0].setReps?.count ?? 0) + 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            let titleCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTitleTableViewCell.identifier, for: indexPath) as! ExerciseSetTitleTableViewCell
            return titleCell
        }
        if indexPath.row == (currentWorkout?.exerciseSets[indexPath.section].setReps?.count ?? 0) + 2{
            let addSetCell = tableView.dequeueReusableCell(withIdentifier: "addSetCell", for: indexPath)
            return addSetCell
        }
        
        if indexPath.row > 1{
            let setCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTableViewCell.indentifier, for: indexPath) as! ExerciseSetTableViewCell
            setCell.configure(with: indexPath.row-1, delegate: self)
            print(indexPath.row)
            //let currentExercise = currentWorkout?.exerciseSets[indexPath.section].setReps?[indexPath.row - 2]
            setCell.repsTextField.text = String(currentWorkout?.exerciseSets[indexPath.section].setReps?[indexPath.row - 2] ?? 0)
            setCell.kgTextField.text = String(currentWorkout?.exerciseSets[indexPath.section].setWeight?[indexPath.row - 2] ?? 0)
            return setCell
        }
        
        
        let exerciseTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        exerciseTitleCell.textLabel?.text = currentWorkout?.exerciseSets[indexPath.section].exerciseName
        return exerciseTitleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let number = indexPath.count
        if indexPath.row == (currentWorkout?.exerciseSets[indexPath.section].setReps?.count ?? 0) + 2{
            let currentExercise = self.currentWorkout?.exerciseSets[indexPath.section]
            currentExercise.setReps?.append(0)
            currentExercise.setWeight?.append(0)
            exercisesTableView.reloadData()
        }
        
    }*/
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "addExerciseSegue"{
           let destination = segue.destination as! ExercisesTableViewController
           destination.delegate = self
       }
       
   }*/
    
    
}
