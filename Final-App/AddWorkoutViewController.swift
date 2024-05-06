//
//  AddWorkoutViewController.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

class AddWorkoutViewController: UIViewController {
    @IBOutlet weak var exercisesTableView: UITableView!
    weak var databaseController: DatabaseProtocol?
    var exercise_sets = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController
        exercisesTableView.register(ExerciseSetTableViewCell.nib(), forCellReuseIdentifier: ExerciseSetTableViewCell.indentifier)
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        exercisesTableView.reloadData()
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
extension AddWorkoutViewController : UITableViewDelegate {
    
}

extension AddWorkoutViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 1 {
            let setCell = tableView.dequeueReusableCell(withIdentifier: ExerciseSetTableViewCell.indentifier, for: indexPath) as! ExerciseSetTableViewCell
            setCell.configure(setIndex: indexPath.row)
            return setCell
        }
        
        let exerciseTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        exerciseTitleCell.textLabel?.text = "Dumbbell Curls"
        return exerciseTitleCell
    }
    
    
}
