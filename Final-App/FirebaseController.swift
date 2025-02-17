//
//  FirebaseController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {

    
    var listeners = MulticastDelegate<DatabaseListener>()
    var workoutList: [Workout] = []
    var authController: Auth
    var database: Firestore
    var usersRef: CollectionReference?
    var workoutsRef: CollectionReference?
    var mealsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    var currentWorkout: Workout?
    var userData = User()
    var authenticationListener: AuthenticationListener?
    
    override init(){
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        super.init()
        
    }
    
    // Adds the listener
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, currentUser: userData)
        }
        if listener.listenerType == .workouts || listener.listenerType == .all{
            listener.onWorkoutsChange(change: .update, workouts: userData.workouts)
        }
    }
    
    // Removes the listener
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    // Adds the user to the database
    func addUser(documentId:String,email:String,name:String) -> User {
        let currentUser = User()
        currentUser.email = email
        currentUser.name = name
        currentUser.userId = documentId
        currentUser.workouts = []
        usersRef = database.collection("users")
        do{
            if let userRef = try usersRef?.document(documentId).setData(from: currentUser){
            }
        } catch {
            print("Failed to serialize user")
        }

        return currentUser
    }
    
    // Adds the workout the the base collection workouts in the database and adds it to the users list of workouts based on which user added the workout
    func addWorkout(newWorkoutName : String , newExerciseSets : [ExerciseSet]) -> Workout{
        let newWorkout = Workout()
        newWorkout.workoutName = newWorkoutName
        newWorkout.exerciseSets = newExerciseSets
        workoutsRef = database.collection("workouts")
        let user = Auth.auth().currentUser
        if let userId = user?.uid {
            usersRef = database.collection("users")
            newWorkout.userId = userId
    
            do {
                if let workoutsRef = try workoutsRef?.addDocument(from: newWorkout){
                    newWorkout.id = workoutsRef.documentID
                    usersRef?.document(userId).updateData(["workouts" : FieldValue.arrayUnion([newWorkout.id])])
                }
            } catch {
                print("Failed to serialize workout")
            }
        }
        return newWorkout
    }
    
    // Adds the meal based on date selected to the collection of meals and updates the user's list of meals that selected the meal
    func addMealToDate(date: String) -> Meals{
        let newMeal = Meals()
        mealsRef = database.collection("meals")
        
        let user = Auth.auth().currentUser
        
        if let userId = user?.uid {
            usersRef = database.collection("users")
            newMeal.userId = userId
            newMeal.mealDate = date
            
            do {
                if let mealsRef = try mealsRef?.addDocument(from: newMeal){
                    newMeal.id = mealsRef.documentID
                    usersRef?.document(userId).updateData(["meals" : FieldValue.arrayUnion([newMeal.id])])
                }
            } catch {
                print("Failed to serialize meal")
            }
        }
        return newMeal
    }
    
    // Updates the meal in the database whenever a food item is added to the list of meals
    func addFoodToMeal(mealToAddTo: Meals, foodItem: FoodSet, mealTime: String){
        mealsRef = database.collection("meals")
        var firestoreData: [String: Any]{
            return [
                "name": foodItem.name,
                "calories": foodItem.calories,
                "serving_size_g": foodItem.serving_size_g,
                "fat_total_g": foodItem.fat_total_g,
                "fat_saturated_g": foodItem.fat_saturated_g,
                "protein_g": foodItem.protein_g,
                "sodium_mg": foodItem.sodium_mg,
                "potassium_mg": foodItem.potassium_mg,
                "cholesterol_mg": foodItem.cholesterol_mg,
                "carbohydrates_total_g": foodItem.carbohydrates_total_g,
                "fiber_g": foodItem.fiber_g,
                "sugar_g": foodItem.sugar_g,
            
            ]
        }
        guard let mealId = mealToAddTo.id else{
            return
        }
        do {
            if let mealsRef = try mealsRef?.document(mealId){
                mealsRef.updateData([mealTime : FieldValue.arrayUnion([firestoreData])])
            }
        }
        catch{
            print("Failed to serialise meal")
        }
    }
    
    // Adds an exercise to the workout
    func addExerciseToWorkout(exercise: ExercisesData) {
        let exerciseSet = ExerciseSet()
        exerciseSet.exerciseName = exercise.name
        exerciseSet.exerciseTarget = exercise.muscle
        exerciseSet.exerciseDifficulty = exercise.difficulty
        exerciseSet.exerciseEquipment = exercise.equipment
        exerciseSet.exerciseInstructions = exercise.instructions
        exerciseSet.setReps = []
        exerciseSet.setWeight = []
    }
    
    

    func cleanup() {
        
    }
    
    // Handles signup checks
    func signUp(email: String, password:String, name: String){
        Task {
            do{
                let authResult = try await authController.createUser(withEmail: email, password: password)
                
                
                self.currentUser = authResult.user
                self.userData = addUser(documentId: authResult.user.uid,email: email,name: name)
                
                DispatchQueue.main.async {
                    self.authenticationListener?.signUpSuccess()
                }
                self.setupUserListener()
                
                
            }
            catch{
                DispatchQueue.main.async {
                    self.authenticationListener?.onAuthenticationError(error: error)
                }
            }
        }
    }

    // Handles sign in checks
    func signIn(email: String, password: String) {
        Task{
            do{
                let authResult = try await authController.signIn(withEmail: email, password: password)
                self.currentUser = authResult.user
                self.setupUserListener()
                //self.setupWorkoutListener()
                DispatchQueue.main.async{
                    self.authenticationListener?.signInSuccess()
                }
                
            }
            catch{
                DispatchQueue.main.async {
                    self.authenticationListener?.onAuthenticationError(error: error)
                }
            }
        }
    }
    
    // Gets the workout based on the document id
    func getWorkoutByID(_ id:String) async -> Workout?{
        workoutsRef = database.collection("workouts")
        
        do{
            let workoutItem = try await workoutsRef?.document(id).getDocument()
            currentWorkout = Workout()
            let workout = try workoutItem?.data(as:Workout.self)
            currentWorkout = workout
            return currentWorkout
        } catch{
            return nil
        }
        
    }
    
    // Gets the meal based on the meal id
    func getMealByID(_ id:String) async -> Meals?{
        mealsRef = database.collection("meals")
        do{
            let mealItem = try await mealsRef?.document(id).getDocument()
            var currentMeal = Meals()
            guard let meal = try mealItem?.data(as:Meals.self) else{
                return nil
            }
            meal.id = id
        
            currentMeal = meal
            return currentMeal
            
        } catch{
            return nil
        }
    }
    
    // Sets up the listeners for changes in users
    func setupUserListener(){
        usersRef = database.collection("users")
        guard let userId = currentUser?.uid else{
            return
        }
        usersRef?.whereField("userId", isEqualTo: userId).addSnapshotListener{
            (querySnapshot,error) in
            guard let querySnapshot = querySnapshot, let userSnapshot = querySnapshot.documents.first else{
                print("Error fetching User: \(error!)")
                return
            }
            self.parseUsersSnapshot(snapshot: userSnapshot)
            Task{
                
                await self.parseWorkoutSnapshot(snapshot: userSnapshot)

            }
                }
    }
    
    // Sets up to listen for changes in workouts
    func setupWorkoutListener(){
        workoutsRef = database.collection("workouts")
        guard let userId = currentUser?.uid else{
            return
        }
        workoutsRef?.whereField("userId", isEqualTo: userId).addSnapshotListener(){
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot?.documents.first else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            Task{
                await self.parseWorkoutSnapshot(snapshot: querySnapshot)
            }
            
        }
        
    }
    
    // Parse the users
    func parseUsersSnapshot(snapshot: QueryDocumentSnapshot){
        userData = User()
        userData.name = snapshot.data()["name"] as? String
        userData.userId = snapshot.data()["userId"] as? String
        userData.email = snapshot.data()["email"] as? String
        userData.id = snapshot.documentID
        
        
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all {
                listener.onUserChange(change: .update, currentUser: userData)
                }
            }
        
    }
    
    // Parse the workouts and meals
    func parseWorkoutSnapshot(snapshot: QueryDocumentSnapshot) async{
        guard currentUser != nil else{
            return
        }
        userData = User()
        userData.name = snapshot.data()["name"] as? String
        userData.userId = snapshot.data()["userId"] as? String
        userData.email = snapshot.data()["email"] as? String
        userData.id = snapshot.documentID
        if let workoutReferences = snapshot.data()["workouts"] as? [String] {
            for reference in workoutReferences {
                if let workoutItem = await getWorkoutByID(reference){
                    userData.workouts.append(workoutItem)
                }
            }
        }
        if let mealReferences = snapshot.data()["meals"] as? [String] {
            for reference in mealReferences {
                if let mealItem = await getMealByID(reference){
                    userData.meals.append(mealItem)
                }
                
            }
            
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all {
                listener.onWorkoutsChange(change: .update, workouts: userData.workouts)
                listener.onMealsChange(change: .update, meals: userData.meals)
            }
        }
        
    }
    

    // Signs the user out
    func signOut(){
        do{
            let _: () = try authController.signOut()
        }
        catch{
            print("Couldn't Sign out")
        }

        
    }
}
