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
    
    var locationCoordinates = CLLocation()

    
    

    
    
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
            if self.calculateButton.isEnabled {
                self.calculateButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.calculateButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                let addedActivity = Activity(activity: self.activityLabel.text!, time: self.timePicker.date, endTime: self.endTimePicker.date, location: self.location.text!, transport: self.transportTypeLabel.text!, timeString: self.timeStampe, endTimeString: self.timeStampe2, coordinates: self.locationCoordinates, travelTime: 0, type: "Activity")
                var temp = true
                // check if timeslot is available for the activity
                for activity in addedActivities {
                    if (addedActivity.time >= activity.time && addedActivity.time <= activity.endTime) ||  (addedActivity.endTime >= activity.time && addedActivity.endTime <= activity.endTime) || ( addedActivity.time <= activity.time && addedActivity.endTime >= activity.endTime) {
                        temp = false
                        
                        let alertController = UIAlertController(title: "Eror", message: "There is already an activity planned during this period of time. Please change time.", preferredStyle: .alert)
                        
                        let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        
                        alertController.addAction(declineAction)
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
                
                // if time slot is available, add activity and traveltime
                if temp == true {
                    addedActivities.append(addedActivity)
                    if addedActivities.count > 1 {
                        self.calculateTravelTime(startLocation: addedActivities[addedActivities.count-2].coordinates, endLocation: addedActivities[addedActivities.count-1].coordinates, transportationMode: addedActivities[addedActivities.count-1].transport)
                            }
                    if addedActivities.count == 1 {
                        self.calculateTravelTime(startLocation: startLocationDictionary[selectedDate]!, endLocation: addedActivities[0].coordinates, transportationMode: addedActivities[0].transport)
                    }

    
                    dateDictionary["\(selectedDate)"] = addedActivities
                }
            }
        }
    }
    
    
    /// allow users to fill in an activity in the textfield
    @IBAction func addActivity(_ sender: UITextField) {
        userData = true
        activity.append(activityLabel.text!)
        UserDefaults.standard.set(activity, forKey: "theActivity")
        time.append(timeStampe)
        UserDefaults.standard.set(time, forKey: "theTime")
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
    
    ///
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
        autoCompleteController.delegate = self as GMSAutocompleteViewControllerDelegate
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func calculateTravelTime(startLocation: CLLocation, endLocation: CLLocation, transportationMode: String) {
        //Import JSON, import Swifty
        
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url2 = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&mode=\(transportationMode)&key=AIzaSyDs9-PYsYSVlhHhZJFJ-jyLZ9azoyA1oSY"
        
        
        Alamofire.request(url2).responseJSON { response in
         
         do {
         
            let json = try JSON(data: response.data!)
            travelTime = json["rows"][0]["elements"][0]["duration"]["value"].intValue
            print(" The travel time is: \(travelTime)")
            let travelTimeStart = Calendar.current.date(byAdding: .second, value: -travelTime, to: (addedActivities.last?.time)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            if travelTime != 0 {
                if addedActivities.count > 1 {
                    let travelActivity = Activity(activity: (addedActivities.last?.transport)!, time: travelTimeStart!, endTime: (addedActivities.last?.time)!, location: addedActivities[addedActivities.count-2].location, transport: (addedActivities.last?.transport)!, timeString: dateFormatter.string(from: travelTimeStart!), endTimeString: self.timeStampe, coordinates: addedActivities[addedActivities.count-2].coordinates, travelTime: travelTime, type: "Travel")
                    addedActivities.append(travelActivity)
                } else {
                    let travelActivity = Activity(activity: (addedActivities.last?.transport)!, time: travelTimeStart!, endTime: (addedActivities.last?.time)!, location: addedActivities[addedActivities.count-1].location, transport: (addedActivities.last?.transport)!, timeString: dateFormatter.string(from: travelTimeStart!), endTimeString: self.timeStampe, coordinates: addedActivities[0].coordinates, travelTime: travelTime, type: "Travel")
                    addedActivities.append(travelActivity)
                }
            }
            
         } catch {
            print("Komt deze functie hier?")
            }
        }
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

public extension UISearchBar {
    
    public func setPlaceHolder(string: String) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.placeholder = string
    }
}
