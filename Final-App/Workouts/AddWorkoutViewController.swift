//
//  AddWorkoutViewController.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

class AddWorkoutViewController: UIViewController,DatabaseListener, ExerciseAddedDelegate {
    func onMealsChange(change: DatabaseChange, meals: [Meals]) {
        
    }
    

    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    
    var listenerType: ListenerType = .user
    var currentUser = User()
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var exercisesTableView: UITableView!
    
    weak var firebaseController: FirebaseController?
    weak var databaseController: DatabaseProtocol?
    
    var exercise_sets = [ExerciseSet]()
    
    @IBAction func addExerciseToWorkout(_ sender: Any) {
         
    }
    
    // This method allowed me to append the exercise to the list of exercises each time I select an exercise in the list of exercises
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if let exerciseViewController = seg.source as? ExercisesTableViewController{
            for exerciseSet in exerciseViewController.exerciseSets {
                self.exercise_sets.append(exerciseSet) // Append the exercises
            }
        }
        exercisesTableView.reloadData() // Reload the view to see the new exercises
    }
    
    @IBAction func addWorkoutToUser(_ sender: Any) {
        let cells = self.exercisesTableView.visibleCells
        
        for cell in cells {
            if cell.reuseIdentifier == "ExerciseSetTableViewCell" {
                print(cell)
            }
        }
        
        // Call the firebase controller method that adds the workouts to firebase under the current user
        let exerciseAdded = self.databaseController?.addWorkout(newWorkoutName: workoutNameTextField.text ?? "name", newExerciseSets: exercise_sets)
        // Return to the previous user
        navigationController?.popViewController(animated: true)
        
    }
    
    // Everytime user changes, update the current user
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
    }
    
    // Adds exercise to the current list of exercises and reloads the view
    func exercisesAdded(_ exerciseSet: ExerciseSet) {
        self.exercise_sets.append(exerciseSet)
        exercisesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController as? FirebaseController
        // Register custom cells
        exercisesTableView.register(UINib(nibName: "ExerciseSetTableViewCell", bundle: nil),forCellReuseIdentifier: ExerciseSetTableViewCell.indentifier)
        exercisesTableView.register(UINib(nibName: "ExerciseSetTitleTableViewCell", bundle: nil), forCellReuseIdentifier: ExerciseSetTitleTableViewCell.identifier)
        // Connects the table view
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        // Load the table
        exercisesTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // Adds the view as a listener
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    // Removes the view as a listener
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    

}
extension AddWorkoutViewController : UITableViewDelegate, cellTextFieldDelegate {
    
    // This function updates each of the sets weight or reps when the text is entered into the text fields
    func updateExerciseSet(with kgText: Int?, repsText: Int?, for cell: ExerciseSetTableViewCell) {
        guard let indexPath = self.exercisesTableView.indexPath(for: cell) else{ // Gets which exercise is being edited based on the index path
            return
        }
        // Update the data for that exercise
        self.exercise_sets[indexPath.section].setWeight?[indexPath.row - 2] = kgText ?? 0
        self.exercise_sets[indexPath.section].setReps?[indexPath.row - 2] = repsText ?? 0
        // Reload the table with the updated data
        self.exercisesTableView.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
}

extension AddWorkoutViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercise_sets.count // Number of sections are number of exercises
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We have the number of sets + 3 as one row is for the exercise name, one for the column headings and one for adding sets
        return (exercise_sets[section].setReps?.count ?? 0) + 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1{ // The column headings
            let titleCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTitleTableViewCell.identifier, for: indexPath) as! ExerciseSetTitleTableViewCell
            return titleCell
        }
        if indexPath.row == (exercise_sets[indexPath.section].setReps?.count ?? 0) + 2{ // The row that allows us to add sets
            let addSetCell = tableView.dequeueReusableCell(withIdentifier: "addSetCell", for: indexPath)
            return addSetCell
        }
        
        if indexPath.row > 1{ // All the set data
            let setCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTableViewCell.indentifier, for: indexPath) as! ExerciseSetTableViewCell
            setCell.configure(with: indexPath.row-1, delegate: self)
            setCell.delegate = self
            // This is so we can access the cell where text fields were edited
            let section = indexPath.section + 1
            let row = indexPath.row + 1
            let kg = 1
            let reps = 2
            // Format the tags so we can check when text fields are edited
            setCell.repsTextField.tag = Int("\(reps)0\(section)0\(row)")!
            setCell.repsTextField.delegate = self
            setCell.kgTextField.tag = Int("\(kg)0\(section)0\(row)")!
            setCell.kgTextField.delegate = self
            
            // Set as nil if 0 so we have no text at first
            setCell.repsTextField.text = String(exercise_sets[indexPath.section].setReps?[indexPath.row - 2] ?? 28)
            if setCell.repsTextField.text == "0"{
                setCell.repsTextField.text = nil
            }
            setCell.kgTextField.text = String(exercise_sets[indexPath.section].setWeight?[indexPath.row - 2] ?? 24)
            if setCell.kgTextField.text == "0"{
                setCell.kgTextField.text = nil
            }
            return setCell
        }
        
        // First row should be the title of the exercise
        let exerciseTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        exerciseTitleCell.textLabel?.text = exercise_sets[indexPath.section].exerciseName
        return exerciseTitleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50// Sets cell height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (exercise_sets[indexPath.section].setReps?.count ?? 0) + 2{ // Only if we selected the add set row
            let currentExercise = self.exercise_sets[indexPath.section]
            // Adds 0s for each new set added which we can modify when text fields are updated
            currentExercise.setReps?.append(0)
            currentExercise.setWeight?.append(0)
            exercisesTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "addExerciseSegue"{
           let destination = segue.destination as! ExercisesTableViewController // This allows us to add exercises to the workout when we segue to the list of exercises view
           destination.delegate = self
       }
       
   }
    
    
    
    
}

extension AddWorkoutViewController: UITextFieldDelegate {
    // This method updates the data based on the text field edited
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("HI")
        print(textField.tag)
        // Here i obtain the index path from the tags i set when setting the cells
        let indexString = "\(textField.tag)"
        let parts = indexString.components(separatedBy: "0")
        let type = Int(parts[0])!
        let row = Int(parts[2])! - 1
        let section = Int(parts[1])! - 1
        
        if type == 1{ // 1 is for my weight fields
            self.exercise_sets[section].setWeight?[row - 2] = Int(textField.text ?? "88") ?? 97
        }
        if type == 2{ // 2 is for my reps felds
            self.exercise_sets[section].setReps?[row - 2] = Int(textField.text ?? "88") ?? 97
        }
        
    }
}
