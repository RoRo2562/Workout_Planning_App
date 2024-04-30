//
//  HomeViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, DatabaseListener {
    var currentUser = User()
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
        if let currentName = currentUser.name{
            welcomeLabel.text = "Welcome " + currentName
        }
        
    }
    @IBAction func toExercises(_ sender: Any) {

    }
    
    

    
    var listenerType: ListenerType = .user
    weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var welcomeLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        
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
