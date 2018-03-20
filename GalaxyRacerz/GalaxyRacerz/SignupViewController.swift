//
//  SignupViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 3/20/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

protocol CredentialsDelegate {
    func passUserInfo(userInfo: Any?)
}

class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate: CredentialsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func arrowButtonPressed(_ sender: Any) {
        //print(UserDefaults.standard.dictionaryRepresentation())
        //let kUsername = "userId"
        //let kPassword = "passId"
        let defaults = UserDefaults.standard
        
        let userId = usernameTextField.text!
        let passId = passwordTextField.text!
        let kUsername = userId
        //let kPassword = passId
        //defaults.set("", forKey: kUsername)
        
        if(defaults.object(forKey: kUsername) != nil) {
            let alert = UIAlertController(title:"Signup Error", message:"Username already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler:nil))
            present(alert, animated: true, completion: nil)
        }
        else {
        
            defaults.set(passId, forKey: kUsername)
            //defaults.set(passId, forKey: kPassword)
        
            let newUser = User()
            newUser.username = userId
            newUser.password = passId
        
            delegate?.passUserInfo(userInfo: defaults)
        }
    
    }
    
}
