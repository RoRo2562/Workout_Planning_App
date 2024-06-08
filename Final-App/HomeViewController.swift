//
//  HomeViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit
import Firebase
import HealthKit

class HomeViewController: UIViewController, DatabaseListener {
    let healthStore = HKHealthStore()
    func onMealsChange(change: DatabaseChange, meals: [Meals]) {
        
    }
    
    
    var listenerType: ListenerType = .user // We want to listen for changes in user logged in
    weak var databaseController: DatabaseProtocol? // This is the database protocol we need to conform to
    var currentUser = User() // The current user data in the user class object format
    @IBOutlet weak var welcomeLabel: UILabel! // Welcome label
    
    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    // This function implements the functionality of when the user logged in changes
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
        if let currentName = currentUser.name{
            welcomeLabel.text = "Welcome " + currentName
        }
        
    }
    @IBAction func toExercises(_ sender: Any) {

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        if HKHealthStore.isHealthDataAvailable(){
            
        }
        
        
        //welcomeLabel.text
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
