//
//  PlannerViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 07/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAlert() {
        
        let alertController = UIAlertController(title: "Add Activity", message: "Would you like to optimize for travel time?", preferredStyle: .alert)
        
        
        let optimize = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "optimize", sender: self) 
        }
        let noOptimization = UIAlertAction(title: "No", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "noOptimize", sender: self)
        }
        let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(optimize)
        alertController.addAction(noOptimization)
        alertController.addAction(declineAction)

        
        present(alertController, animated: true, completion: nil)
    }

}
