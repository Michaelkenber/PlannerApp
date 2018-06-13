//
//  PlannerViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 07/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

var activity = [String]()
var time = [String]()
var userData = false

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(activity.count)
        return activity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        print(time)
        cell.textLabel?.text = "\(activity[indexPath.row]) at \(time[indexPath.row])"
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = UserDefaults.standard.bool(forKey: "userData")
        
        if userData == true {
            activity = UserDefaults.standard.object(forKey: "theActivity") as! [String]
            time = UserDefaults.standard.object(forKey: "theTime") as! [String]
        } else {
            activity.append("NO USER DATA")
            UserDefaults.standard.set(activity, forKey: "theActivity")
            if activity[0] == "NO USER DATA" {
                activity.remove(at: 0)
                UserDefaults.standard.set(activity, forKey: "theActivity")
            time.append("NO USER DATA")
            UserDefaults.standard.set(time, forKey: "theTime")
            if time[0] == "NO USER DATA" {
                    time.remove(at: 0)
                    UserDefaults.standard.set(time, forKey: "theTime")
                }
            }
        }
        tableView.reloadData()
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
    
    @IBAction func unwindToPlanner(unwindSegue: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            activity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: . automatic)
            UserDefaults.standard.set(activity, forKey: "theEvent")
        }
        tableView.reloadData()
    }


}
