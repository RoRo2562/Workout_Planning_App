//
//  AddWorkoutViewController.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

class AddWorkoutViewController: UIViewController,DatabaseListener {
    var listenerType: ListenerType = .user
    var currentUser = User()
    
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
    }
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var exercisesTableView: UITableView!
    
    weak var firebaseController: FirebaseController?
    weak var databaseController: DatabaseProtocol?
    
    var exercise_sets = [ExerciseSet]()
    
    @IBAction func addExerciseToWorkout(_ sender: Any) {
         func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addExerciseSegue"{
                let destination = segue.destination as! ExercisesTableViewController
                destination.exerciseSets = self.exercise_sets
            }
            
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if let exerciseViewController = seg.source as? ExercisesTableViewController{
            for exerciseSet in exerciseViewController.exerciseSets {
                self.exercise_sets.append(exerciseSet)
            }
        }
        exercisesTableView.reloadData()
    }
    
    @IBAction func addWorkoutToUser(_ sender: Any) {
        
        self.firebaseController?.addWorkout(newWorkoutName: workoutNameTextField.text ?? "name", newExerciseSets: exercise_sets)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController
        exercisesTableView.register(UINib(nibName: "ExerciseSetTableViewCell", bundle: nil),forCellReuseIdentifier: ExerciseSetTableViewCell.indentifier)
        exercisesTableView.register(UINib(nibName: "ExerciseSetTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ExerciseSetTitleTableViewCell.identifier)
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        exercisesTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
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
extension AddWorkoutViewController : UITableViewDelegate {
    
}

extension AddWorkoutViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercise_sets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (exercise_sets[section].setReps?.count ?? 0) + 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            let titleCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTitleTableViewCell.identifier, for: indexPath) as! ExerciseSetTitleTableViewCell
            return titleCell
        }
        if indexPath.row == (exercise_sets[indexPath.section].setReps?.count ?? 0) + 2{
            let addSetCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            addSetCell.textLabel?.text = "Add a set"
            return addSetCell
        }
        
        if indexPath.row > 1{
            let setCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTableViewCell.indentifier, for: indexPath) as! ExerciseSetTableViewCell
            setCell.configure(with: indexPath.row-1)
            return setCell
        }
        
        
        let exerciseTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        exerciseTitleCell.textLabel?.text = exercise_sets[indexPath.section].exerciseName
        return exerciseTitleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let number = indexPath.count
        if indexPath.row == (exercise_sets[indexPath.section].setReps?.count ?? 0) + 2{
            let currentExercise = self.exercise_sets[indexPath.section]
            currentExercise.setReps?.append(0)
            currentExercise.setWeight?.append(0)
            exercisesTableView.reloadData()
        }
        
    }
    
    
}
