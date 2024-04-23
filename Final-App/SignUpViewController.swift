//
//  SignUpViewController.swift
//  Final-App
//
//  Created by Roro on 23/4/2024.
//

import UIKit

class SignUpViewController: UIViewController,AuthenticationListener {

    weak var databaseController: FirebaseController?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text, let name = nameTextField.text else{
            return
        }
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
        //navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "signUpSegue", sender: Any?.self)
    }
    
    func signInSuccess() {
        
    }
    
    func onAuthenticationError(error: any Error) {
        displayMessage(title: "Error", message: error.localizedDescription)
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
