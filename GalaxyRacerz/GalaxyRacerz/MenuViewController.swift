//
//  MenuViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 4/4/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selected = UIImage(named: "texture")
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showGame",
            let dest = segue.destination as? GameViewController
        {
            dest.image = selected
        }
    }

}
