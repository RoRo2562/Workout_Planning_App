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
    
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, currentUser: userData)
        }
        if listener.listenerType == .workouts || listener.listenerType == .all{
            listener.onWorkoutsChange(change: .update, workouts: userData.workouts)
        }
    }
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
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
        /*if let userRef = usersRef?.addDocument(data: ["team" : addTeam(teamName: user.uid)]){
            currentUser.id = userRef.documentID
        }*/
        return currentUser
    }
    
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
    
    func addMealToday() -> Meals{
        let newMeal = Meals()
        mealsRef = database.collection("meals")
        
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateInFormat = dateFormatter.string(from: todaysDate as Date)
        
        let user = Auth.auth().currentUser
        
        if let userId = user?.uid {
            usersRef = database.collection("users")
            newMeal.userId = userId
            newMeal.mealDate = dateInFormat
            
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
    
    
    func signUp(email: String, password:String, name: String){
        Task {
            do{
                let authResult = try await authController.createUser(withEmail: email, password: password)
                
                //let user = User()
                self.currentUser = authResult.user
                self.userData = addUser(documentId: authResult.user.uid,email: email,name: name)
                
                DispatchQueue.main.async {
                    self.authenticationListener?.signUpSuccess()
                }
                self.setupUserListener()
                //self.setupWorkoutListener()
                
                /*if let userRef = try await usersRef?.addDocument(data: ["team" : addTeam(teamName: authResult.user.uid)]){
                    user.id = userRef.documentID
                }*/
                
            }
            catch{
                DispatchQueue.main.async {
                    self.authenticationListener?.onAuthenticationError(error: error)
                }
            }
        }
    }

    
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
    
    func getMealByID(_ id:String) async -> Meals?{
        mealsRef = database.collection("workouts")
        do{
            let mealItem = try await mealsRef?.document(id).getDocument()
            var currentMeal = Meals()
            guard let meal = try mealItem?.data(as:Meals.self) else{
                return nil
            }
            // This section gets todays date to see if the meal we have found in the list of meals is todays meals
            let todaysDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateInFormat = dateFormatter.string(from: todaysDate as Date)
            
            // We compare the date of the meals in the list of meals to todays date, if its not today then we don't want to display the data
            currentMeal = meal
            return currentMeal
            
        } catch{
            return nil
        }
    }
    
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
    
    func parseWorkoutSnapshot(snapshot: QueryDocumentSnapshot) async{
        guard let loggedUser = currentUser else{
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
            // We want to check if the user has not logged in today which would result in no meal being stored for today
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all {
                listener.onWorkoutsChange(change: .update, workouts: userData.workouts)
                listener.onMealsChange(change: .update, todaysMeal: userData.meals)
            }
        }
        
    }
    
    func parseMealsSnapshot(snapshot: QueryDocumentSnapshot) async{
        guard let loggedUser = currentUser else{
            return
        }
        
    }
    
    func signOut(){
        do{
            let authResult: () = try authController.signOut()
        }
        catch{
            print("Couldn't Sign out")
        }

        
    }
}
