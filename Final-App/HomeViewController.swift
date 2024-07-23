//
//  HomeViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit
import Firebase
import HealthKit

// This is the main home view
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
