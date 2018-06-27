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
        
        let alertController = UIAlertController(title: "Add activity", message: "Would you like to add an activity?", preferredStyle: .alert)
        
        
        let optimize = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "optimize", sender: self) 
        }

        let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(optimize)
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
        
        let startLocation = UIAlertAction(title: "Change Start location", style: .default) { (_) -> Void in
            
            self.getStartLocation()
        }

        let declineAction = UIAlertAction(title: "Never mind", style: .cancel, handler: nil)
        

        alertController.addAction(declineAction)
        alertController.addAction(startLocation)
        
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
