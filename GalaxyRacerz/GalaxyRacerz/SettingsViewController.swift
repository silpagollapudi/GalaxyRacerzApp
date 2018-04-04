//
//  SettingsViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 4/4/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let defaults = UserDefaults.standard
    var selected = UIImage(named: "texture")
    
    @IBAction func selectDefaultShip(_ sender: Any) {
        defaults.set("texture", forKey: "shipColor")
    }
    
    @IBAction func selectBlackShip(_ sender: Any) {
        defaults.set("textureBlack", forKey: "shipColor")
    }
    
    @IBAction func selectYellowShip(_ sender: Any) {
        defaults.set("textureYellow", forKey: "shipColor")
    }
    
    @IBAction func selectPurpleShip(_ sender: Any) {
        defaults.set("texturePurple", forKey: "shipColor")
    }
    
    @IBAction func selectGreenShip(_ sender: Any) {
        defaults.set("textureGreen", forKey: "shipColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
