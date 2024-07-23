//
//  NutritionHomeViewController.swift
//  Final-App
//
//  Created by Roro on 6/6/2024.
//

import UIKit
import HorizonCalendar

// This is the nutrition home view controller
class NutritionHomeViewController: UIViewController, UICalendarSelectionSingleDateDelegate,DatabaseListener {
    
    var listenerType: ListenerType = .all
    var currentUser = User()
    var meals: [Meals?] = []
    weak var databaseController: DatabaseProtocol?
    var mealSelected : Meals?

    
    private var selectedDay: DayComponents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        createCalendar()
        
    }
    // Handles the logic for when a day is selected in the calendar
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let year = dateComponents?.year else{
            return
        }
        guard let month = dateComponents?.month else{
            return
        }
        guard let day = dateComponents?.day else{
            return
        }
        let dateString = "\(String(day))-\(String(month))-\(String(year))" // Formats the date into the same string structure stored in firebase
        for meals in currentUser.meals{
            if meals.mealDate == dateString{ // If the date already has existing meal data, load the data
                self.mealSelected = meals
            }
        }
        if self.mealSelected?.mealDate != dateString{
            self.mealSelected = self.databaseController?.addMealToDate(date: dateString) // Otherwise create a new meal and add it to the database
        }
        performSegue(withIdentifier: "viewDietSegue", sender: Any?.self) // Transition to the nutrition view controller to see the meal data for the date selected
    }
    
    // Function that creates the calendar
    func createCalendar() {
        let calendarView = UICalendarView(frame: UIScreen.main.bounds)
        
        // Sets up the calendar structure
        calendarView.calendar = .current
        calendarView.tintColor = .red
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        // Adds the calendar to the view
        self.view.addSubview(calendarView)
                  
        
    }
    
    // Sets the current user based on if the user changes
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
    }
    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
    // Updates the list of meals if it changes
    func onMealsChange(change: DatabaseChange, meals: [Meals]) {
        self.meals = meals
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "viewDietSegue"{
           let destination = segue.destination as! NutritionViewController
           destination.currentMeal = self.mealSelected // Set the data in the next view controller as the meal selected
       }
       
   }

}


