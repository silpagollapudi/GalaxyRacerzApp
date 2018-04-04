//
//  LoginViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 3/20/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userInputText: UITextField!
    @IBOutlet weak var passInputText: UITextField!
    
    @IBAction func arrowButtonPressed(_ sender: Any) {
 
        let defaults = UserDefaults.standard
        
        let userId = userInputText.text!
        let passId = passInputText.text!
        let kUsername = userId
        
        if(userId.trimmingCharacters(in: .whitespaces).isEmpty || passId.trimmingCharacters(in: .whitespaces).isEmpty) {
            let alert = UIAlertController(title:"Login Error", message:"One or more field is blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(defaults.object(forKey: kUsername) == nil || (String(describing: (defaults.object(forKey: kUsername))!) != passId)) {
            let alert = UIAlertController(title:"Login Error", message:"Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.performSegue(withIdentifier: "showMain", sender: AnyClass.self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
