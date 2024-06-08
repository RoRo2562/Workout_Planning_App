//
//  ExercisesTableViewController.swift
//  Final-App
//
//  Created by Roro on 30/4/2024.
//

import UIKit
protocol ExerciseAddedDelegate: AnyObject{
    func exercisesAdded(_ exerciseSet: ExerciseSet)
}

class ExercisesTableViewController: UITableViewController,UISearchBarDelegate, UISearchResultsUpdating
{
    var newExercise = [ExercisesData]()
    var exerciseDetail: ExercisesData?
    let CELL_EXERCISE = "exerciseCell"
    var indicator = UIActivityIndicatorView()
    weak var databaseController: DatabaseProtocol?
    var currentRequestIndex: Int = 0
    let MAX_ITEMS_PER_REQUEST = 40
    var exerciseSets: [ExerciseSet] = []
    var filteredExerciseData :[ExercisesData] = []
    
    let muscleGroups: [String] = ["abdominals",
                                  "abductors",
                                  "adductors",
                                  "biceps",
                                  "calves",
                                  "chest",
                                  "forearms",
                                  "glutes",
                                  "hamstrings",
                                  "lats",
                                  "lower_back",
                                  "middle_back",
                                  "neck",
                                  "quadriceps",
                                  "traps",
                                  "triceps"]
    
    weak var delegate: ExerciseAddedDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        let muscleController = UIPickerView()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        //let searchTextField = searchController.searchBar.value(forKey: "_searchField") as! UITextField
        //searchTextField.inputView = muscleController
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.scopeButtonTitles = ["All","Arms","Back","Legs","Chest","Abs"]
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
        indicator.centerXAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.centerXAnchor),
        indicator.centerYAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.centerYAnchor)
        ])
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
            searchController.searchBar.setShowsScope(true, animated: true)
            guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
            }
            
            filteredExerciseData = newExercise.filter({(exercise: ExercisesData) -> Bool in
                if searchController.searchBar.selectedScopeButtonIndex == 0{
                    return true
                }
                if searchController.searchBar.selectedScopeButtonIndex == 1{
                    if exercise.muscle == "biceps" || exercise.muscle == "forearms" || exercise.muscle == "traps" || exercise.muscle == "triceps" || exercise.muscle == "shoulders"{
                        return true
                    }
                }
                if searchController.searchBar.selectedScopeButtonIndex == 2{
                    if exercise.muscle == "lower_back" || exercise.muscle == "middle_back" || exercise.muscle == "lats" || exercise.muscle == "neck"{
                        return true
                    }
                }
                if searchController.searchBar.selectedScopeButtonIndex == 3{
                    if exercise.muscle == "abductors" || exercise.muscle == "adductors" || exercise.muscle == "calves" || exercise.muscle == "glutes" || exercise.muscle == "hamstrings" || exercise.muscle == "quadriceps"{
                        return true
                    }
                }
                if searchController.searchBar.selectedScopeButtonIndex == 4{
                    if exercise.muscle == "chest"{
                        return true
                    }
                }
                if searchController.searchBar.selectedScopeButtonIndex == 5{
                    if exercise.muscle == "abdominals"{
                        return true
                    }
                }
                
                return false
        
            })
            
            tableView.reloadData()
        }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredExerciseData.count
    }
    
    func requestExercises(_ exercises:String) async {
        /*
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "www.exercisedb.p.rapidapi.com"
        searchURLComponents.path = "/exercises"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "maxResults", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "startIndex", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "q", value: exercises)
        ]
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }*/
        
        let query = exercises.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/exercises?name="+query!)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("++z2KwnT+PXKDZLnHzEN9Q==z7IB8lELs2QgxqlE", forHTTPHeaderField: "X-Api-Key")
        do {
            let (data,response) = try await URLSession.shared.data(for: urlRequest)
            indicator.stopAnimating()
            let decoder = JSONDecoder()
            print(String(decoding: data, as: UTF8.self))
            let exerciseData = try decoder.decode([ExercisesData].self, from: data)
            newExercise = []
            let startIndex = newExercise.count
            for exercise in exerciseData{
                newExercise.append(exercise)
            }
            filteredExerciseData = newExercise
            
            tableView.reloadData()
            /*
            tableView.performBatchUpdates({
                var indexPaths = [IndexPath]()
                
                for i in 0..<newFood.count{
                    indexPaths.append(IndexPath(row: startIndex + i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)*/
            
            
            
            
            
        }
        catch let error {
            print(error)
        }
    }
    

    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text
        else{return}
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        Task {
            URLSession.shared.invalidateAndCancel()
            currentRequestIndex = 0
            await requestExercises(searchText)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_EXERCISE, for: indexPath)
        
        let exercise = filteredExerciseData[indexPath.row]
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = exercise.muscle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciseSet = ExerciseSet()
        let exercise = filteredExerciseData[indexPath.row]
        exerciseSet.exerciseName = exercise.name
        exerciseSet.exerciseTarget = exercise.muscle
        exerciseSet.exerciseDifficulty = exercise.difficulty
        exerciseSet.exerciseEquipment = exercise.equipment
        exerciseSet.exerciseInstructions = exercise.instructions
        exerciseSet.setReps = []
        exerciseSet.setWeight = []
        self.exerciseSets.append(exerciseSet)
        delegate?.exercisesAdded(exerciseSet)
        //performSegue(withIdentifier: "returnExerciseSetsSegue", sender: self)
        navigationController?.popViewController(animated: true)
        
        
    }
    
    // This function allows us to get the index path for the info button clicked and allows the user to view info on the exercise
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        exerciseDetail = filteredExerciseData[indexPath.row]
        performSegue(withIdentifier: "viewExerciseSegue", sender: Any?.self)
        
    }

    
    // This function allows us to update the exercise view with the exercise we have selected to view the detail for
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewExerciseSegue"{
            let destination = segue.destination as! ExerciseTableViewController
            destination.currentExercise = exerciseDetail

        }
        
    }

    

}
