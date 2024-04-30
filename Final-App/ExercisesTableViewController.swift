//
//  ExercisesTableViewController.swift
//  Final-App
//
//  Created by Roro on 30/4/2024.
//

import UIKit

class ExercisesTableViewController: UITableViewController,UISearchBarDelegate
{
    var newFood = [FoodData]()
    let CELL_EXERCISE = "exerciseCell"
    var indicator = UIActivityIndicatorView()
    weak var databaseController: DatabaseProtocol?
    var currentRequestIndex: Int = 0
    let MAX_ITEMS_PER_REQUEST = 40
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newFood.count
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
        let url = URL(string: "https://api.api-ninjas.com/v1/nutrition?query="+query!)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("++z2KwnT+PXKDZLnHzEN9Q==z7IB8lELs2QgxqlE", forHTTPHeaderField: "X-Api-Key")
        do {
            let (data,response) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            print(String(decoding: data, as: UTF8.self))
            let foodData = try decoder.decode([FoodData].self, from: data)
            let startIndex = newFood.count
            for food in foodData{
                newFood.append(food)
            }
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
        //newBooks.removeAll(where: <#T##(BookData) throws -> Bool#>)
        //tableView.reloadData()
        guard let searchText = searchBar.text
        else{return}
        navigationItem.searchController?.dismiss(animated: true)
        Task {
            URLSession.shared.invalidateAndCancel()
            currentRequestIndex = 0
            await requestExercises(searchText)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_EXERCISE, for: indexPath)
        
        let food = newFood[indexPath.row]
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = String(food.calories)

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
