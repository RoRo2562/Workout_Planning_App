//
//  SignUpViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit

class SignInViewController: UIViewController, AuthenticationListener {
    func signUpSuccess() {
        
    }
    
    func signInSuccess() {
        performSegue(withIdentifier: "signInSegue", sender: Any?.self)
    }
    
    func onAuthenticationError(error: any Error) {
        displayMessage(title: "Error", message: error.localizedDescription)
    }
    
    weak var databaseController : FirebaseController?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text else{
            return
        }
        DispatchQueue.main.async {
            self.databaseController?.signIn(email: email, password: password)
        }
    }
    @IBAction func signUp(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController as? FirebaseController
        databaseController?.authenticationListener = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.databaseController?.signOut()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
