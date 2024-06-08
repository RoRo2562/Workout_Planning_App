//
//  WorkoutsViewController.swift
//  Final-App
//
//  Created by Roro on 14/5/2024.
//

import UIKit

// This is the class where the list of workouts are displayed
class WorkoutsViewController: UIViewController,DatabaseListener {

    
    // Listen for all changes
    var listenerType: ListenerType = .all
    // The current active user
    var currentUser = User()
    var myworkouts : [Workout] = [] // List of the workouts
    weak var databaseController: DatabaseProtocol? // The database controller
    
    @IBOutlet weak var workoutsTableView: UITableView!
    
    // Does the required set up for the user
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        if let currentName = currentUser.name{
            navigationItem.title = currentName + "'s workouts" // On load change the name
        }
        workoutsTableView.reloadData() // Update the table view

        // Do any additional setup after loading the view.
    }
    
    // Do nothing here as meals don't affect workouts
    func onMealsChange(change: DatabaseChange, meals: [Meals]) {
        
    }
    
    // In this function, we update the users name in navigation title and their list of workouts at login
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
        myworkouts = workouts
        DispatchQueue.main.async {
            if let currentName = self.currentUser.name{
                self.navigationItem.title = currentName + "'s workouts"
            }
            self.workoutsTableView.reloadData()
        }
    }
    
    // We update the users name if the user changes
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
        DispatchQueue.main.async {
            if let currentName = self.currentUser.name{
                self.navigationItem.title = currentName + "'s workouts"
            }
        }
        
    }
    
    // Setup the listeners when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    // Remove the listeners when the view dissappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }


}

extension WorkoutsViewController : UITableViewDelegate {
    
}

// Set up for the table view in the page
extension WorkoutsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myworkouts.count // Number of workouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workoutCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        workoutCell.textLabel?.text = myworkouts[indexPath.row].workoutName // Displays the workout name
        return workoutCell
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewWorkoutSegue"{
            let destinationVC = segue.destination as! WorkoutViewController
            if let indexPath = workoutsTableView.indexPathForSelectedRow{
                let currentWorkout = myworkouts[indexPath.row] // We want to segue and view the workout we clicked on
                destinationVC.currentWorkout = currentWorkout
            }
            
        }
        
    }
    
}
