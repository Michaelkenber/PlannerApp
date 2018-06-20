//
//  AddActivityTableViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddActivityTableViewController: UITableViewController, SelectTransportTypeTableViewControllerDelegate, GMSMapViewDelegate ,  CLLocationManagerDelegate {

    @IBOutlet weak var activityLabel: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var transportTypeLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationCoordinates = CLLocation()

    
    

    
    
    var transportType: TransportType?
    
    var timeStampe: String!
    
    let timePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let buttonlIndexPath = IndexPath(row: 1, section: 3)

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
        calculateButton.isEnabled = false
        calculateButton.isUserInteractionEnabled = false
        calculateButton.alpha = 0.5
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
            if self.calculateButton.isEnabled {
                self.calculateButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.calculateButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                let addedActivity = Activity(activity: self.activityLabel.text!, time: self.timePicker.date, location: self.location.text!, transport: self.transportTypeLabel.text!, timeString: self.timeStampe, coordinates: self.locationCoordinates)
                addedActivities.append(addedActivity)
                dateDictionary["\(selectedDate)"] = addedActivities
                
                //UserDefaults.standard.set(self.addedActivities, forKey: "theActivities")
            }
            
            
        }
    }
    
    @IBAction func addActivity(_ sender: UITextField) {
        userData = true
        activity.append(activityLabel.text!)
        UserDefaults.standard.set(activity, forKey: "theActivity")
        time.append(timeStampe)
        UserDefaults.standard.set(time, forKey: "theTime")
        showButton()
    }
    
    func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        timeStampe = dateFormatter.string(from: timePicker.date)
        timeLabel.text = timeStampe
    }
    
    func updateTransportType() {
        if let transportType = transportType {
            transportTypeLabel.text = transportType.name
        } else {
            transportTypeLabel.text = "Select transport mode"
        }
        showButton()
    }
    
    func showButton() {
        if transportTypeLabel.text != "Select transport mode" && location.text != "" && activityLabel.text != "" {
            calculateButton.isEnabled = true
            calculateButton.isUserInteractionEnabled = true
            calculateButton.alpha = 1
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTransportMode" {
            let destinationViewController = segue.destination as? SelectTransportTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.transportType = transportType
        }
    }
    
    @IBAction func openStartLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
}

extension AddActivityTableViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        location.text = "\(place.name)"
        locationCoordinates = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.dismiss(animated: true, completion: nil)
        showButton()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}

