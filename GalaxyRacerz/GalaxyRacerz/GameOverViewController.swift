//
//  GameOverViewController.swift
//  GalaxyRacerz
//
//  Created by Sheetal Poduri on 3/31/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    var tempScoreLabel = String()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func replayButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = tempScoreLabel
        
        let defaults = UserDefaults.standard
        let kHighScore = "highScore" 
 
        let retrievedHighScore = defaults.integer(forKey: kHighScore)
        
        let scoreInt:Int = Int(scoreLabel.text!)!
        
        if (scoreInt > retrievedHighScore) { 
            defaults.set(scoreLabel.text, forKey: kHighScore)
        }
        
        // Do any additional setup after loading the view.
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
