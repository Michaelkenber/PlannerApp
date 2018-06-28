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
    
    @IBOutlet weak var durationLabel: UILabel!
    
    let locationRow = IndexPath(row: 1, section: 0)
    
    @IBOutlet weak var TravelActivityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLabel.text = selectedActivity.activity          // Show activity name
        locationLabel.text = selectedActivity.location          // Show activity location
        startTimeLabel.text = selectedActivity.timeString       // Show activity starting time
        endTimeLabel.text = selectedActivity.endTimeString      // Show activity ending time
        
        // If travel activity give label "Transport mode: ", else "Activity: "
        if selectedActivity.type == "Travel" {
            TravelActivityLabel.text = "Transport Mode:"
        } else {
            TravelActivityLabel.text = "Activity:"
        }
        let cal = Calendar.current
        let components = cal.dateComponents([.minute], from: selectedActivity.time, to: selectedActivity.endTime)
        // Calculate the duration of each activity
        let diff = components.minute!
        
        // Display the minutes on the label
        durationLabel.text = "\(diff) minutes"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Delete location row for travel activity
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (locationRow.section, locationRow.row):
            if selectedActivity.type == "Travel" {
                return 0
            } else {
                return 44.0
            }
        default:
            return 44.0
        }
    }
}
