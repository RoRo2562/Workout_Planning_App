//
//  NutritionHomeViewController.swift
//  Final-App
//
//  Created by Roro on 6/6/2024.
//

import UIKit
import HorizonCalendar

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
        let dateString = "\(String(day))-\(String(month))-\(String(year))"
        for meals in currentUser.meals{
            if meals.mealDate == dateString{
                self.mealSelected = meals
            }
        }
        if self.mealSelected == nil{
            self.mealSelected = self.databaseController?.addMealToDate(date: dateString)
        }
        performSegue(withIdentifier: "viewDietSegue", sender: Any?.self)
    }
    
    func createCalendar() {
        let calendarView = UICalendarView(frame: UIScreen.main.bounds)
        calendarView.calendar = .current
        calendarView.tintColor = .red
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        self.view.addSubview(calendarView)
                  
        
    }
    
    func onUserChange(change: DatabaseChange, currentUser: User) {
        self.currentUser = currentUser
    }
    
    func onWorkoutsChange(change: DatabaseChange, workouts: [Workout]) {
        
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "viewDietSegue"{
           let destination = segue.destination as! NutritionViewController
           destination.currentMeal = self.mealSelected
       }
       
   }

}
/*
extension NutritionHomeViewController: UICalendarSelectionSingleDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let dateString = "\(String(describing: dateComponents?.year))\(String(describing: dateComponents?.day))\(String(describing: dateComponents?.month))"
        print(dateString)
        
    }

    
    
}
*/


