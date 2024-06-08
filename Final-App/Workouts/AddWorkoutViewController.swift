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
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if let exerciseViewController = seg.source as? ExercisesTableViewController{
            for exerciseSet in exerciseViewController.exerciseSets {
                self.exercise_sets.append(exerciseSet)
            }
        }
        exercisesTableView.reloadData()
    }
    
    @IBAction func addWorkoutToUser(_ sender: Any) {
        let cells = self.exercisesTableView.visibleCells
        
        for cell in cells {
            if cell.reuseIdentifier == "ExerciseSetTableViewCell" {
                print(cell)
            }
        }
        
        
        self.databaseController?.addWorkout(newWorkoutName: workoutNameTextField.text ?? "name", newExerciseSets: exercise_sets)
        navigationController?.popViewController(animated: true)
        
    }
    
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
    }
    
    func exercisesAdded(_ exerciseSet: ExerciseSet) {
        self.exercise_sets.append(exerciseSet)
        exercisesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController as? FirebaseController
        
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
extension AddWorkoutViewController : UITableViewDelegate, cellTextFieldDelegate {
    func updateExerciseSet(with kgText: Int?, repsText: Int?, for cell: ExerciseSetTableViewCell) {
        guard let indexPath = self.exercisesTableView.indexPath(for: cell) else{
            return
        }
        self.exercise_sets[indexPath.section].setWeight?[indexPath.row - 2] = kgText ?? 0
        self.exercise_sets[indexPath.section].setReps?[indexPath.row - 2] = repsText ?? 0
        
        self.exercisesTableView.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
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
            let addSetCell = tableView.dequeueReusableCell(withIdentifier: "addSetCell", for: indexPath)
            return addSetCell
        }
        
        if indexPath.row > 1{
            let setCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTableViewCell.indentifier, for: indexPath) as! ExerciseSetTableViewCell
            setCell.configure(with: indexPath.row-1, delegate: self)
            setCell.delegate = self
            let section = indexPath.section + 1
            let row = indexPath.row + 1
            let kg = 1
            let reps = 2
            setCell.repsTextField.tag = Int("\(reps)0\(section)0\(row)")!
            setCell.repsTextField.delegate = self
            setCell.kgTextField.tag = Int("\(kg)0\(section)0\(row)")!
            setCell.kgTextField.delegate = self
            
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
    /*
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let cell = exercisesTableView.cellForRow(at: indexPath)
                    else
                {
                    return
                }
        if (cell.isKind(of: ExerciseSetTableViewCell.self)){
            let currentExercise = self.exercise_sets[indexPath.section]
            currentExercise.setReps?[indexPath.row - 2] = cell.repsTextField
            currentExercise.setWeight?.append(0)
            exercisesTableView.reloadData()
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "addExerciseSegue"{
           let destination = segue.destination as! ExercisesTableViewController
           destination.delegate = self
       }
       
   }
    
    
    
    
}

extension AddWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("HI")
        print(textField.tag)
        let indexString = "\(textField.tag)"
        let parts = indexString.components(separatedBy: "0")
        let type = Int(parts[0])!
        let row = Int(parts[2])! - 1
        let section = Int(parts[1])! - 1
        if type == 1{
            self.exercise_sets[section].setWeight?[row - 2] = Int(textField.text ?? "88") ?? 97
        }
        if type == 2{
            self.exercise_sets[section].setReps?[row - 2] = Int(textField.text ?? "88") ?? 97
        }
        
    }
}
