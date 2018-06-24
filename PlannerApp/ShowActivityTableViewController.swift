//
//  ShowActivityTableViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 21/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class ShowActivityTableViewController: UITableViewController {

    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLabel.text = selectedActivity.activity
        locationLabel.text = selectedActivity.location
        startTimeLabel.text = selectedActivity.timeString
        endTimeLabel.text = selectedActivity.endTimeString
        travelTime.text = "1 hour"
        durationLabel.text = "1 hour"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
}
