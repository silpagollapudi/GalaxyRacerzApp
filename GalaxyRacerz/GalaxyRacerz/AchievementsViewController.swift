//
//  AchievementsViewController.swift
//  GalaxyRacerz
//
//  Created by Sheetal Poduri on 4/13/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        let kHighScore = "highScore"

        let retrievedHighScore = String(describing: defaults.object(forKey: kHighScore)!)
        
        highScoreLabel.text = retrievedHighScore
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
