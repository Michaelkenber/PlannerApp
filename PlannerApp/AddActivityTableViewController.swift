//
//  AddActivityTableViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class AddActivityTableViewController: UITableViewController, SelectTransportTypeTableViewControllerDelegate {

    @IBOutlet weak var activity: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var transportTypeLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    var transportType: TransportType?
    
    
    let timePickerCellIndexPath = IndexPath(row: 1, section: 1)

    var timePickerShown: Bool = false {
        didSet {
            timePicker.isHidden = !timePickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Calendar.current.startOfDay(for: Date())
        timePicker.minimumDate = today
        timePicker.date = today
        timePicker.datePickerMode = UIDatePickerMode.time
        
        updateViews()
    }
    
    func didSelect(transportType: TransportType) {
        self.transportType = transportType
        updateTransportType()
    }
    
    
    @IBAction func timePickerValueChanged(_ sender: UIDatePicker) {
        updateViews()
        updateTransportType()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (timePickerCellIndexPath.section, timePickerCellIndexPath.row):
            if timePickerShown {
                return 216.0
            } else {
                return 0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (timePickerCellIndexPath.section, timePickerCellIndexPath.row - 1):
            
            if timePickerShown {
                timePickerShown = false
            } else {
                timePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }

    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.calculateButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.calculateButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    
    func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        timeLabel.text = dateFormatter.string(from: timePicker.date)
    }
    
    func updateTransportType() {
        if let transportType = transportType {
            transportTypeLabel.text = transportType.name
        } else {
            transportTypeLabel.text = "Select transport mode"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTransportMode" {
            let destinationViewController = segue.destination as? SelectTransportTypeTableViewController
            
            destinationViewController?.delegate = self
            destinationViewController?.transportType = transportType
        }
    }

}
