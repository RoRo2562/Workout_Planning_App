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
    func addListener(listener: any DatabaseListener) {
        
    }
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var usersRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    var userData: User?
    var authenticationListener: AuthenticationListener?
    
    override init(){
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        super.init()
        
    }
    /*
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, currentUser: currentUser!)
        }
    }*/
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    func addUser(documentId:String,email:String,name:String) -> User {
        let currentUser = User()
        currentUser.email = email
        currentUser.name = name
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
    
    

    func cleanup() {
        
    }
    
    
    func signUp(email: String, password:String, name: String){
        Task {
            do{
                let authResult = try await authController.createUser(withEmail: email, password: password)
                
                //let user = User()
                self.currentUser = authResult.user
                self.setupUserListener()
                self.userData = addUser(documentId: authResult.user.uid,email: email,name: name)
                DispatchQueue.main.async {
                    self.authenticationListener?.signUpSuccess()
                }
                
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
    
    func setupUserListener(){
        usersRef = database.collection("users")
        guard let userEmail = currentUser?.email else{
            return
        }
        usersRef?.whereField("email", isEqualTo: userEmail).addSnapshotListener{
            (querySnapshot,error) in
            guard let querySnapshot = querySnapshot, let userSnapshot = querySnapshot.documents.first else{
                print("Error fetching teams: \(error!)")
                return
            }
            self.parseUsersSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseUsersSnapshot(snapshot: QuerySnapshot){
        guard let currentUser = self.userData else{
            return
        }
        
        snapshot.documentChanges.forEach{(change) in
            var user : User
            do {
                user = try change.document.data(as: User.self)
            } catch {
                fatalError("Unable to decode hero: \(error.localizedDescription)")
            }
            listeners.invoke{ (listener) in
                if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all {
                    guard let userData = self.userData else{
                        return
                    }
                }
            }
        }
    }
}
