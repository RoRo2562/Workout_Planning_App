//
//  WorkoutsViewController.swift
//  Final-App
//
//  Created by Roro on 14/5/2024.
//

import UIKit

class WorkoutsViewController: UIViewController,DatabaseListener {
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        myworkouts = workouts
        //workoutsTableView.reloadData()
    }
    
    
    var listenerType: ListenerType = .all
    var currentUser = User()
    var myworkouts : [Workout] = []
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var workoutsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        workoutsTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
        if let currentName = currentUser.name{
            navigationItem.title = currentName + "'s workouts"
        }
        
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

extension WorkoutsViewController : UITableViewDelegate {
    
}

extension WorkoutsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myworkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workoutCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        workoutCell.textLabel?.text = myworkouts[indexPath.row].workoutName
        return workoutCell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = indexPath.row
        performSegue(withIdentifier: "workoutViewSegue", sender: Any?.self)
        
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewWorkoutSegue"{
            let destinationVC = segue.destination as! WorkoutViewController
            if let indexPath = workoutsTableView.indexPathForSelectedRow{
                let currentWorkout = myworkouts[indexPath.row]
                destinationVC.currentWorkout = currentWorkout
            }
            
        }
        
    }
    
}
