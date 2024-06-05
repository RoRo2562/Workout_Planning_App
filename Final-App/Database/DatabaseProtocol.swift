//
//  DatabaseProtocol.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import Foundation
import Firebase

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case user
    case workouts
    case exercises
    case meal
    case all
}

protocol DatabaseListener: AnyObject{
    var listenerType: ListenerType {get set}
    func onUserChange(change:DatabaseChange,currentUser: User)
    func onWorkoutsChange(change:DatabaseChange,workouts:[Workout])
    func onMealsChange(change:DatabaseChange,todaysMeal:[Meals])
}

protocol AuthenticationListener: AnyObject{
    func signUpSuccess()
    func signInSuccess()
    func onAuthenticationError(error:Error)
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func signUp(email:String,password:String, name:String)
    func signIn(email:String,password:String)
    func addWorkout(newWorkoutName : String , newExerciseSets : [ExerciseSet]) -> Workout
    func addMealToday() -> Meals
}

