//
//  PlannerViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 07/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
// This is the viewcontroller that displays the daily activities of the user

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

var addedActivities = [Activity]()
var sortedActivities = [Activity]()
var activity = [String]()
var time = [String]()
var dateDictionary: [String: [Activity]] = [:]
var selectedDate = String()
var selectedActivity: Activity!
var startLocationDictionary: [String: Coordinate] = [:]
let propertyListDecoder = PropertyListDecoder()
let documentsDirectory =
    FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask).first!
let archiveURL =
    documentsDirectory.appendingPathComponent("dateDictionary")
        .appendingPathExtension("plist")
let archiveURL2 =
    documentsDirectory.appendingPathComponent("locationDictionary")
        .appendingPathExtension("plist")

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate ,  CLLocationManagerDelegate {

    @IBOutlet weak var titlePlanner: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Define the number of rows as the number of activities
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateDictionary[selectedDate]!.count
    }
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var locationCoordinates: Coordinate!
    
    /// Tell each cell how to display the activity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        print(time)
        sortedActivities = (dateDictionary[selectedDate]?.sorted(by: <))!
        cell.textLabel?.text = "\(sortedActivities[indexPath.row].activity) from \(sortedActivities[indexPath.row].timeString) to \(sortedActivities[indexPath.row].endTimeString)"
        
        
        return cell
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Set the title to the date the user has selected
        selectedDate = titlePlanner.title!
        // If the user has selected a location in the past, set the prompt to that location, else, ask for a location
        if let _ = startLocationDictionary["\(selectedDate)"] {
            titlePlanner.prompt = "Starting location: \(startLocationDictionary["\(selectedDate)"]!.placeName)"
        } else {
            titlePlanner.prompt = "Starting location: "
            let alertController = UIAlertController(title: "Start Location", message: "Please fill in the starting location for \(selectedDate)" , preferredStyle: .alert)
            
            
            let ok = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in
                self.getStartLocation()
            }
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        let propertyListDecoder = PropertyListDecoder()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        // Get current date in medium format
        let currentDate = formatter.string(from: date)
        // Set currend date as selected date when screen is loaded
        selectedDate = currentDate
        
        // Try to retrieve the user given activities from the plist
        if let retrievedDictionary = try? Data(contentsOf: archiveURL),
            let decodedDictionary = try? propertyListDecoder.decode([String: [Activity]].self, from: retrievedDictionary) {
            dateDictionary = decodedDictionary
            if dateDictionary[selectedDate] != nil {
                addedActivities = dateDictionary[selectedDate]!
            }
        }
        
        // Try to download the user given location from the plist
        if let retrievedLocation = try? Data(contentsOf: archiveURL2),
            let decodedDictionary = try? propertyListDecoder.decode([String: Coordinate].self, from: retrievedLocation) {
            startLocationDictionary = decodedDictionary
        }
        super.viewDidLoad()
        titlePlanner.title = currentDate
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Alow users to add or delete activities
    @IBAction func showAlert() {
        
        let alertController = UIAlertController(title: "Add activity", message: "Would you like to add an activity, or delete all activities for the day", preferredStyle: .alert)
        
        
        let addActivity = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "optimize", sender: self) 
        }
        
        let deleteAll = UIAlertAction(title: "Delete all activities", style: .default) { (_) -> Void in
            addedActivities = []
            dateDictionary[selectedDate] = addedActivities
            self.tableView.reloadData()
            
        }

        let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActivity)
        alertController.addAction(declineAction)
        alertController.addAction(deleteAll)

        present(alertController, animated: true, completion: nil)
    }
    
    /// Prepare for unwind
    @IBAction func unwindToPlanner(unwindSegue: UIStoryboardSegue) {
        
    }
    
    /// When row is selected, perform segue to show details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addedActivities.count > 0 {
            sortedActivities = (dateDictionary[selectedDate]?.sorted(by: <))!
            selectedActivity = sortedActivities[indexPath.item]
            self.performSegue(withIdentifier: "showActivity", sender: self)
        }
    }
    
    /// Define how to receive data from CalenderViewController
    @IBAction func unwindToDate(segue: UIStoryboardSegue)
    {

         let sourceViewController = segue.source as!
         CalendarViewController
        // Receive the selected date from calendar view controller
         if let newDate = sourceViewController.newDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let currentDate = formatter.string(from: newDate)
            titlePlanner.title = "\(currentDate)"
            // If activities exist for the date, let them be displa
            if let value = dateDictionary["\(currentDate)"] {
                addedActivities = value
            } else {
                dateDictionary["\(currentDate)"] = []
                addedActivities = dateDictionary["\(currentDate)"]!
            }
        
         }
        tableView.reloadData()
    }
    
    /// Get the starting location from the view controller
    func getStartLocation() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self as GMSAutocompleteViewControllerDelegate
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        UISearchBar.appearance().setPlaceHolder(string: "Please give a starting location for \(selectedDate)")
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    /// Change the starting location for that day
    @IBAction func ChangeStartLocationButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Change start location", message: "Would you like to change the start location?", preferredStyle: .alert)
        
        let startLocation = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            self.getStartLocation()
        }

        let declineAction = UIAlertAction(title: "Never mind", style: .cancel, handler: nil)
        

        alertController.addAction(declineAction)
        alertController.addAction(startLocation)
        
        present(alertController, animated: true, completion: nil)
    }
}

/// Extend the planner viewcontroler with GMSautocompletecontroller to receive startcoordinates
extension PlannerViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationCoordinates = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, placeName: "\(place.name)")
        startLocationDictionary["\(selectedDate)"] = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, placeName: "\(place.name)")
        titlePlanner.prompt = "Starting location: \(place.name)"
        let propertyListEncoder = PropertyListEncoder()
        let encodedCoordinate = try? propertyListEncoder.encode(startLocationDictionary)
        
        try? encodedCoordinate?.write(to: archiveURL2, options: .noFileProtection)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
