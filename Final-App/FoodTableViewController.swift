//
//  FoodTableViewController.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

protocol FoodAddedDelegate: AnyObject{
    func foodAdded(_ foodItem: FoodSet, _ mealSection: Int)
}

class FoodTableViewController: UITableViewController,UISearchBarDelegate, CoreDataListener, DatabaseListener {
    func onUserChange(change: DatabaseChange, currentUser: User) {
        
    }
    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    func onMealsChange(change: DatabaseChange, meals: [Meals]) {
        
    }
    
    var listenerType: ListenerType = .all
    
    func onFoodsChange(change: DatabaseChange, foodList: [Food]) {
        newFood = foodList
    }
    
    var foodDetail: Food?
    var newFood = [Food]()
    var mealAddedTo: Int = 0
    let CELL_FOOD = "foodCell"
    var indicator = UIActivityIndicatorView()
    weak var databaseController: DatabaseProtocol?
    weak var coreDatabaseController: CoreDatabaseProtocol?
    var currentRequestIndex: Int = 0
    let MAX_ITEMS_PER_REQUEST = 40
    weak var delegate: FoodAddedDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        
        // Search bar logic
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Handle the indicator
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
        coreDatabaseController = appDelegate?.coreDatabaseController

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
    
    // This function takes the string typed in the search bar and loads the list of food items that match the name of the food item
    func requestFood(_ foods: String) async {
        let formattedFoods = foods.replacingOccurrences(of: ",", with: " ")
        let query = formattedFoods.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/nutrition?query="+query!)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("++z2KwnT+PXKDZLnHzEN9Q==z7IB8lELs2QgxqlE", forHTTPHeaderField: "X-Api-Key")
        do {
            let (data,response) = try await URLSession.shared.data(for: urlRequest)
            indicator.stopAnimating()
            let decoder = JSONDecoder()
            print(String(decoding: data, as: UTF8.self))
            let foodData = try decoder.decode([FoodData].self, from: data)
            let startIndex = newFood.count
            for food in foodData{
                // Create a new Food Class entity for the food item
                /*
                let foodItem = Food()
                foodItem.name = food.name
                foodItem.calories = food.calories
                foodItem.serving_size_g = food.serving_size_g
                foodItem.fat_total_g = food.fat_total_g
                foodItem.fat_saturated_g = food.fat_saturated_g
                foodItem.protein_g = food.protein_g
                foodItem.sodium_mg = food.sodium_mg
                foodItem.potassium_mg = food.potassium_mg
                foodItem.cholesterol_mg = food.cholesterol_mg
                foodItem.carbohydrates_total_g = food.carbohydrates_total_g
                foodItem.fiber_g = food.fiber_g
                foodItem.sugar_g = food.sugar_g
                */
                var food_already = false
                for foods in newFood{
                    if foods.name == food.name{
                        food_already = true
                    }
                }
                
                if food_already == false{
                    guard let thisFood = coreDatabaseController?.addFood(name: food.name, calories: food.calories, serving_size_g: food.serving_size_g, fat_total_g: food.fat_total_g, fat_saturated_g: food.fat_saturated_g, protein_g: food.protein_g, sodium_mg: food.sodium_mg, potassium_mg: food.potassium_mg, cholesterol_mg: food.cholesterol_mg, carbohydrates_total_g: food.carbohydrates_total_g, fiber_g: food.fiber_g, sugar_g: food.sugar_g) else { return }
                    
                    newFood.append(thisFood)
                }
                
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
    
    // This function checks if the user has finished typing, if they do call the request food function
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text
        else{return}
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating() // Shows the load animation
        Task {
            URLSession.shared.invalidateAndCancel()
            currentRequestIndex = 0
            await requestFood(searchText)
        }
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_FOOD, for: indexPath)
        let food = newFood[indexPath.row]
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = String(food.calories) + " calories"
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodItem = newFood[indexPath.row]
        let foodSet = FoodSet()
        foodSet.name = foodItem.name
        foodSet.calories = foodItem.calories
        foodSet.serving_size_g = foodItem.serving_size_g
        foodSet.fat_total_g = foodItem.fat_total_g
        foodSet.fat_saturated_g = foodItem.fat_saturated_g
        foodSet.protein_g = foodItem.protein_g
        foodSet.sodium_mg = foodItem.sodium_mg
        foodSet.potassium_mg = foodItem.potassium_mg
        foodSet.cholesterol_mg = foodItem.cholesterol_mg
        foodSet.carbohydrates_total_g = foodItem.carbohydrates_total_g
        foodSet.fiber_g = foodItem.fiber_g
        foodSet.sugar_g = foodItem.sugar_g
        delegate?.foodAdded(foodSet, mealAddedTo)
        //performSegue(withIdentifier: "returnExerciseSetsSegue", sender: self)
        navigationController?.popViewController(animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        foodDetail = newFood[indexPath.row]
        performSegue(withIdentifier: "viewFoodSegue", sender: Any?.self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewFoodSegue"{
            let destination = segue.destination as! FoodItemTableViewController
            destination.currentFood = foodDetail

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDatabaseController?.addListener(listener: self)
    }
    
    // Remove the listeners when the view dissappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coreDatabaseController?.removeListener(listener: self)
    }


}
