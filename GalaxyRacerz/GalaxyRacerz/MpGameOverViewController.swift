//
//  MpGameOverViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 4/19/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit

class MpGameOverViewController: UIViewController {

    var outcomeLabel = String()
    @IBOutlet weak var mpResult: UILabel!
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        mpResult.text = outcomeLabel
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
