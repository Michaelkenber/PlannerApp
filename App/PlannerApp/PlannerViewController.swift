//
//  PlannerViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 07/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

var addedActivities = [Activity]()
var sortedActivities = [Activity]()
var activity = [String]()
var time = [String]()
var userData = false
var dateDictionary: [String: [Activity]] = [:]
var selectedDate = String()
var selectedActivity: Activity!
var startLocationDictionary: [String: Coordinate] = [:]
var travelTimes = [Int]()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedActivities.count
    }
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var locationCoordinates: Coordinate!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        print(time)
        if dateDictionary[selectedDate] != nil {
            sortedActivities = (dateDictionary[selectedDate]?.sorted(by: <))!
            cell.textLabel?.text = "\(sortedActivities[indexPath.row].activity) from \(sortedActivities[indexPath.row].timeString) to \(sortedActivities[indexPath.row].endTimeString)"
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedDate = titlePlanner.title!
        if let _ = startLocationDictionary["\(selectedDate)"] {
            titlePlanner.prompt = "Starting location: \(startLocationDictionary["\(selectedDate)"]?.placeName as! String)"
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
        if let retrievedDictionary = try? Data(contentsOf: archiveURL),
            let decodedDictionary = try? propertyListDecoder.decode([String: [Activity]].self, from: retrievedDictionary) {
            dateDictionary = decodedDictionary
            if dateDictionary[selectedDate] != nil {
                addedActivities = dateDictionary[selectedDate]!
            }
        }
        if let retrievedLocation = try? Data(contentsOf: archiveURL2),
            let decodedDictionary = try? propertyListDecoder.decode([String: Coordinate].self, from: retrievedLocation) {
            startLocationDictionary = decodedDictionary
        }
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let currentDate = formatter.string(from: date)
        titlePlanner.title = currentDate
        selectedDate = currentDate
        
        /*
        
        userData = UserDefaults.standard.bool(forKey: "userData")
        
        if userData == true {
            startLocationDictionary = UserDefaults.standard.object(forKey: "theActivity") as! [String: CLLocation]
        } else {
            /*
            activity.append("NO USER DATA")
            UserDefaults.standard.set(activity, forKey: "theActivity")
            if activity[0] == "NO USER DATA" {
                activity.remove(at: 0)
                UserDefaults.standard.set(activity, forKey: "theActivity")
            }
            */
        }
        */
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    @IBAction func unwindToPlanner(unwindSegue: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addedActivities.count > 0 {
            sortedActivities = addedActivities.sorted(by: <)
            selectedActivity = sortedActivities[indexPath.item]
            self.performSegue(withIdentifier: "showActivity", sender: self)
        }
    }
    
    @IBAction func unwindToDate(segue: UIStoryboardSegue)
    {

         //guard segue.identifier == "saveUnwind" else { return }
         let sourceViewController = segue.source as!
         ViewController
         if let newDate = sourceViewController.newDate {
            print(newDate)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let currentDate = formatter.string(from: newDate)
            titlePlanner.title = "\(currentDate)"
            if let value = dateDictionary["\(currentDate)"] {
                addedActivities = value
            } else {
                dateDictionary["\(currentDate)"] = []
                addedActivities = dateDictionary["\(currentDate)"]!
            }
        
         }
        tableView.reloadData()
    }
    
    func getStartLocation() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self as GMSAutocompleteViewControllerDelegate
        
        
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        UISearchBar.appearance().setPlaceHolder(string: "Please give a starting location for \(selectedDate)")
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func optimizeButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Change start location", message: "Would you like to change the start location?", preferredStyle: .alert)
        
        let startLocation = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            self.getStartLocation()
        }

        let declineAction = UIAlertAction(title: "Never mind", style: .cancel, handler: nil)
        

        alertController.addAction(declineAction)
        alertController.addAction(startLocation)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func calculateTravelTime(startLocation: Coordinate, endLocation: Coordinate, transportationMode: String) {
        //Import JSON, import Swifty
        
        
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        let url2 = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&mode=\(transportationMode)&key=AIzaSyDs9-PYsYSVlhHhZJFJ-jyLZ9azoyA1oSY"
        
        
        Alamofire.request(url2).responseJSON { response in
            
            do {
                
                let json = try JSON(data: response.data!)
                travelTime = json["rows"][0]["elements"][0]["duration"]["value"].intValue
                travelTimes.append(travelTime)
                print(travelTimes)
                

            } catch {
                print("Komt deze functie hier?")
            }
        }
    }
}


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
