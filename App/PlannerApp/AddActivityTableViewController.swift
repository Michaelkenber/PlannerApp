//
//  AddActivityTableViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 11/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
// This is the viewcontroller where a user can add an activity

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

var travelTime = 0
let propertyListEncoder = PropertyListEncoder()



class AddActivityTableViewController: UITableViewController, SelectTransportTypeTableViewControllerDelegate, GMSMapViewDelegate ,  CLLocationManagerDelegate {

    @IBOutlet weak var activityLabel: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var transportTypeLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationCoordinates: Coordinate!

    
    

    
    
    var transportType: TransportType?
    
    var timeStampe: String!
    
    var timeStampe2: String!
    
    let timePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let endTimePickerCellIndexPath = IndexPath(row: 3, section: 1)

    // determine a bool variable wether the timepicker for the starttime is shown
    var timePickerShown: Bool = false {
        didSet {
            timePicker.isHidden = !timePickerShown
        }
    }
    
    // determine a bool variable wether the timepicker for the endtime is shown
    var endTimePickerShown: Bool = false {
        didSet {
            endTimePicker.isHidden = !endTimePickerShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Calendar.current.startOfDay(for: Date())
        timePicker.minimumDate = today
        endTimePicker.minimumDate = today
        timePicker.date = today
        endTimePicker.date = today
        calculateButton.isEnabled = false
        calculateButton.isUserInteractionEnabled = false
        calculateButton.alpha = 0.5
        updateViews()
    }
    
    /// determine the transporttype that the user selected
    func didSelect(transportType: TransportType) {
        self.transportType = transportType
        updateTransportType()
    }
    
    /// update label if timepicker is changed
    @IBAction func timePickerValueChanged(_ sender: UIDatePicker) {
        updateViews()
        updateTransportType()
    }
    
    /// if user time pickershwon is true, the timepicker will increase in size from 0 to 216
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (timePickerCellIndexPath.section, timePickerCellIndexPath.row):
            if timePickerShown {
                return 216.0
            } else {
                return 0
            }
        case (endTimePickerCellIndexPath.section, endTimePickerCellIndexPath.row):
            if endTimePickerShown {
                return 216.0
            } else {
                return 0
            }
        default:
            return 44.0
        }
    }
    
    /// if time is selected, show time picker and hide the other time picker
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (timePickerCellIndexPath.section, timePickerCellIndexPath.row - 1):
            
            if timePickerShown {
                timePickerShown = false
            } else if endTimePickerShown {
                endTimePickerShown = false
                timePickerShown = true
            } else {
                timePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (endTimePickerCellIndexPath.section, endTimePickerCellIndexPath.row - 1):
            
            if endTimePickerShown {
                endTimePickerShown = false
            } else if timePickerShown {
                timePickerShown = false
                endTimePickerShown = true
            } else {
                endTimePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    /// add activity when button is pressed
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            // define how to act if button is pressed
            if self.calculateButton.isEnabled {
                // Increase button size when pressed
                UIView.animate(withDuration: 0.2) {
                    self.calculateButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                    self.calculateButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                // Define latest added ativity
                let addedActivity = Activity(activity: self.activityLabel.text!, time: self.timePicker.date, endTime: self.endTimePicker.date, location: self.location.text!, transport: self.transportTypeLabel.text!, timeString: self.timeStampe, endTimeString: self.timeStampe2, coordinates: self.locationCoordinates, travelTime: 0, type: "Activity")
                var timeSlotAvailable = true
                // Check if timeslot is available for the activity
                for activity in addedActivities {
                    if (addedActivity.time >= activity.time && addedActivity.time <= activity.endTime) ||  (addedActivity.endTime >= activity.time && addedActivity.endTime <= activity.endTime) || ( addedActivity.time <= activity.time && addedActivity.endTime >= activity.endTime) {
                        // If timeslot not availabkle set temp to false
                        timeSlotAvailable = false
                        
                        // Display message that timeslot is not available
                        let alertController = UIAlertController(title: "Eror", message: "There is already an activity planned during this period of time. Please change time.", preferredStyle: .alert)
                        
                        let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
                        alertController.addAction(declineAction)
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
                
                // If time slot is available, add activity and traveltime
                if timeSlotAvailable == true {
                    addedActivities.append(addedActivity)
                    var activities = [Activity]()
                    // Select only the non travel activities
                    for activity in addedActivities {
                        if activity.type == "Activity" {
                            activities.append(activity)
                        }
                        
                    }
                    
                    addedActivities = activities
                    activities = activities.sorted(by: <)
                    // Calculate travel times between activities
                    if activities.count > 1 {
                        for index in 0...(activities.count - 2) {
                            self.calculateTravelTime(activity1: activities[index], activity2: activities[index+1])
                            }
                    }
                    // Make a temporary activity, representing the star of the day
                    let startOfDay = Activity(activity: "Start", time: Date(), endTime: Date(), location: (startLocationDictionary[selectedDate]?.placeName)!, transport: "None", timeString: "None", endTimeString: "None" , coordinates: startLocationDictionary[selectedDate]!, travelTime: 0, type: "Temporary")
                    // Calculate traveltime, between day start and first real activity
                    self.calculateTravelTime(activity1: startOfDay, activity2: activities[0])

                    // Add the activity to the date dictionary
                    dateDictionary["\(selectedDate)"] = addedActivities
                    
                    // Encode the date dictionary to a plist file
                    let propertyListEncoder = PropertyListEncoder()
                    let encodedDictionary = try? propertyListEncoder.encode(dateDictionary)                    
                    try? encodedDictionary?.write(to: archiveURL, options: .noFileProtection)
                    
                }
            }
        }
    }
    
    
    /// allow users to fill in an activity in the textfield
    @IBAction func addActivity(_ sender: UITextField) {
        time.append(timeStampe)
        showButton()
    }
    
    /// update the viewcontroller
    func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        timeStampe = dateFormatter.string(from: timePicker.date)
        timeStampe2 = dateFormatter.string(from: endTimePicker.date)
        if endTimePicker.date < timePicker.date {
            endTimePicker.minimumDate = timePicker.date
            endTimeLabel.text = timeStampe
        } else {
            endTimeLabel.text = timeStampe2
        }
        timeLabel.text = timeStampe
    }
    
    /// Update the transport type
    func updateTransportType() {
        if let transportType = transportType {
            transportTypeLabel.text = transportType.name
        } else {
            transportTypeLabel.text = "Select transport mode"
        }
        showButton()
    }
    
    // Show button, after user has filled in everything
    func showButton() {
        if transportTypeLabel.text != "Select transport mode" && location.text != "" && activityLabel.text != "" {
            calculateButton.isEnabled = true
            calculateButton.isUserInteractionEnabled = true
            calculateButton.alpha = 1
        }
    }
    
    /// Prepare for receiving transport type
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTransportMode" {
            let destinationViewController = segue.destination as? SelectTransportTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.transportType = transportType
        }
    }
    
    /// Alow users to choose the location of the action
    @IBAction func openStartLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self as GMSAutocompleteViewControllerDelegate
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    /// A function for calculation the traveltime between two activities
    /// It takes in two activity structs
    func calculateTravelTime(activity1: Activity, activity2: Activity) {
        //Import JSON, import Swifty
        
        // Define travel start
        let origin = "\(activity1.coordinates.latitude),\(activity1.coordinates.longitude)"
        
        // Define travel destination
        let destination = "\(activity2.coordinates.latitude),\(activity2.coordinates.longitude)"
        
        // Define google distance matrix api
        let url2 = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&mode=\(activity2.transport)&key=AIzaSyDs9-PYsYSVlhHhZJFJ-jyLZ9azoyA1oSY"
        
        // Request data from url
        Alamofire.request(url2).responseJSON { response in
         
         do {
         
            let json = try JSON(data: response.data!)                                       // Try if data exists
            travelTime = json["rows"][0]["elements"][0]["duration"]["value"].intValue       // Retrieve travel time from google
            let travelTimeStart = Calendar.current.date(byAdding: .second, value: -travelTime, to: activity2.time)      // Calculate travel start
            let dateFormatter = DateFormatter()            // Define dat formate
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            
            // Only add travel time, if it is not zero
            if travelTime != 0 {
                let travelActivity = Activity(activity: activity2.transport, time: travelTimeStart!, endTime: activity2.time, location: activity1.location, transport: activity2.transport, timeString: dateFormatter.string(from: travelTimeStart!), endTimeString: activity2.timeString, coordinates: activity1.coordinates, travelTime: travelTime, type: "Travel")
                    addedActivities.append(travelActivity)

                dateDictionary[selectedDate] = addedActivities
                let propertyListEncoder = PropertyListEncoder()
                let encodedDictionary = try? propertyListEncoder.encode(dateDictionary)
                try? encodedDictionary?.write(to: archiveURL, options: .noFileProtection)
            }
         } catch {
            print(error)
            }
        }
    }
}

/// Extension to AddActivityTableViewControlle that catches the coordinates of the location the user has chosen
extension AddActivityTableViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        location.text = "\(place.name)"
        locationCoordinates = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, placeName: "\(place.name)")
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

public extension UISearchBar {
    
    public func setPlaceHolder(string: String) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.placeholder = string
    }
}
