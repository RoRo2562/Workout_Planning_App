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
    
            do {
                if let workoutsRef = try workoutsRef?.addDocument(from: newWorkout){
                    newWorkout.id = workoutsRef.documentID
                    usersRef?.document(userId).updateData(["workouts" : FieldValue.arrayUnion([newWorkout])])
                }
            } catch {
                print("Failed to serialize workout")
            }
        }
        return newWorkout
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
    
    func getWorkoutByID(_ id:String) -> Workout?{
        for workout in workoutList{
            if workout.id == id{
                return workout
            }
        }
        return nil
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
    /*
    func parseWorkoutSnapshot(snapshot: QueryDocumentSnapshot){
        guard let loggedUser = currentUser else{
            return
        }
        userData = User()
        userData.email = snapshot.data()["email"] as? String
        userData.name = snapshot.data()["name"] as? String
        userData.userId = snapshot.data()["userId"] as? String
        userData.id = snapshot.documentID
        if let workoutReferences = snapshot.data()["workouts"] as? [DocumentReference] {
            for reference in workoutReferences {
                if let workout = getWorkoutByID(reference.documentID){
                    userData.workouts.append(workout)
                }
            }
        }
        
    }*/
}
