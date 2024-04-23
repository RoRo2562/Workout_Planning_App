//
//  HomeViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit

class HomeViewController: UIViewController,DatabaseListener {
    func onUserChange(change: DatabaseChange, currentUser: User) {
        let name = currentUser.name
    }
    

    
    var listenerType: ListenerType = .user
    var currentUser: User = User()
    weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var welcomeLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        guard let name = currentUser.name else{
            return
        }
        welcomeLabel.text = "Welcome" + "name"
        //welcomeLabel.text
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
