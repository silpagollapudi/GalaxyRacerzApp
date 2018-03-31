//
//  SignupViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 3/20/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func arrowButtonPressed(_ sender: Any) {

        let defaults = UserDefaults.standard
        
        let userId = usernameTextField.text!
        let passId = passwordTextField.text!
        let kUsername = userId
        
        if(userId.trimmingCharacters(in: .whitespaces).isEmpty || passId.trimmingCharacters(in: .whitespaces).isEmpty) {
            let alert = UIAlertController(title:"Signup Error", message:"One or more field is blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(defaults.object(forKey: kUsername) != nil) {
            let alert = UIAlertController(title:"Signup Error", message:"Username already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler:nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            defaults.set(passId, forKey: kUsername)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
