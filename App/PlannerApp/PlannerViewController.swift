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
var startLocationDictionary: [String: CLLocation] = [:]
var travelTimes = [Int]()

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate ,  CLLocationManagerDelegate {

    @IBOutlet weak var titlePlanner: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(addedActivities.count)
        return addedActivities.count
    }
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var locationCoordinates = CLLocation()
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        print(time)
        sortedActivities = addedActivities.sorted(by: <)
        cell.textLabel?.text = "\(sortedActivities[indexPath.row].activity) from \(sortedActivities[indexPath.row].timeString) to \(sortedActivities[indexPath.row].endTimeString)"
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedDate = titlePlanner.title!
        if let _ = startLocationDictionary["\(selectedDate)"] {
        } else {
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
        
        let alertController = UIAlertController(title: "Add activity", message: "Would you like to add an activity or change the starting location", preferredStyle: .alert)
        
        
        let optimize = UIAlertAction(title: "Add activity", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "optimize", sender: self) 
        }
        let noOptimization = UIAlertAction(title: "Change Start location", style: .default) { (_) -> Void in
            
            self.getStartLocation()
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
            sortedActivities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: . automatic)
            //UserDefaults.standard.set(activity, forKey: "theEvent")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addedActivities.count > 0 {
            sortedActivities = addedActivities.sorted(by: <)
            selectedActivity = sortedActivities[indexPath.item]
            self.performSegue(withIdentifier: "showActivity", sender: self)
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        <#code#>
    }
  */
    
    
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
        let alertController = UIAlertController(title: "Travel Time Optimizer", message: "Would you like to optimize for travel time?", preferredStyle: .alert)
        
        
        let optimize = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            let alertController2 = UIAlertController(title: "Transport", message: "What is the preferred mode of transport?", preferredStyle: .alert)
            var transport = ""
            
            let driving = UIAlertAction(title: "driving", style: .default) { (_) -> Void in
                transport = "driving"
            }
            let walking = UIAlertAction(title: "walking", style: .default) { (_) -> Void in
                transport = "walking"
            }
            let bycicling = UIAlertAction(title: "bycicling", style: .default) { (_) -> Void in
                transport = "bycicling"
            }
            let transit = UIAlertAction(title: "transit", style: .default) { (_) -> Void in
                transport = "transit"
            }
            alertController2.addAction(driving)
            alertController2.addAction(walking)
            alertController2.addAction(bycicling)
            alertController2.addAction(transit)
            
            for activity in addedActivities {
                if activity.type == "Activity" {
                    self.calculateTravelTime(startLocation: startLocationDictionary["\(selectedDate)"]!, endLocation: activity.coordinates, transportationMode: transport)
                }
            }
            
            for activity in addedActivities {
                if activity.type == "Activity" {
                    for activity2 in addedActivities {
                        if activity.type == "Activity" && activity != activity2 {
                            self.calculateTravelTime(startLocation: activity.coordinates, endLocation: activity2.coordinates, transportationMode: transport)
                        }
                    }
                }
            }
            
            
            self.present(alertController2, animated: true, completion: nil)
        }

        let declineAction = UIAlertAction(title: "Never mind", style: .cancel, handler: nil)
        
        alertController.addAction(optimize)
        alertController.addAction(declineAction)
        
        present(alertController, animated: true, completion: nil)
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
        locationCoordinates = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        startLocationDictionary["\(selectedDate)"] = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        titlePlanner.prompt = "Starting location: \(place.name)"
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
