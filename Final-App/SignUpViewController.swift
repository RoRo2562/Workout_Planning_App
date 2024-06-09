//
//  SignUpViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit

// This class handles the sign ups and logs the user in once they sign up
class SignUpViewController: UIViewController,AuthenticationListener {

    weak var databaseController: FirebaseController?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text, let name = nameTextField.text else{
            return
        }
        // Checks that all the text fields are full or not, If they are empty, print the error message
        if name.isEmpty || email.isEmpty || password.isEmpty{
            var errorMsg = "Please ensure all fields are filled:\n"
            if name.isEmpty {
                errorMsg += "- Must provide a name\n"
            }
            if email.isEmpty {
                errorMsg += "- Must provide a email\n"
            }
            if password.isEmpty {
                errorMsg += "- Must provide a password\n"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        DispatchQueue.main.async {
            self.databaseController?.signUp(email: email, password: password, name: name)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController as? FirebaseController
        databaseController?.authenticationListener = self

        // Do any additional setup after loading the view.
    }
    
    func signUpSuccess() {
        // Brings us to the home page logged in with the sign up values
        performSegue(withIdentifier: "signUpSegue", sender: Any?.self)
    }
    
    func signInSuccess() {
        
    }
    
    // If the sign up values are not valid print the erro
    func onAuthenticationError(error: any Error) {
        displayMessage(title: "Error", message: error.localizedDescription)
    }
    


}
