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

var addedActivities = [Activity]()
var activity = [String]()
var time = [String]()
var userData = false
var dateDictionary: [String: [Activity]] = [:]
var selectedDate = String()
var selectedActivity: Activity!
var startLocationDictionary: [String: CLLocation] = [:]

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
        var sortedActivities = addedActivities.sorted(by: <)
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
        
        userData = UserDefaults.standard.bool(forKey: "userData")
        
        if userData == true {
            activity = UserDefaults.standard.object(forKey: "theActivity") as! [String]
            time = UserDefaults.standard.object(forKey: "theTime") as! [String]
        } else {
            activity.append("NO USER DATA")
            UserDefaults.standard.set(activity, forKey: "theActivity")
            if activity[0] == "NO USER DATA" {
                activity.remove(at: 0)
                UserDefaults.standard.set(activity, forKey: "theActivity")
            time.append("NO USER DATA")
            UserDefaults.standard.set(time, forKey: "theTime")
            if time[0] == "NO USER DATA" {
                    time.remove(at: 0)
                    UserDefaults.standard.set(time, forKey: "theTime")
                }
            }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAlert() {
        
        let alertController = UIAlertController(title: "Add Activity", message: "Would you like to optimize for travel time?", preferredStyle: .alert)
        
        
        let optimize = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "noOptimize", sender: self) 
        }
        let noOptimization = UIAlertAction(title: "No", style: .default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "optimize", sender: self)
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
            activity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: . automatic)
            UserDefaults.standard.set(activity, forKey: "theEvent")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addedActivities.count > 0 {
            var sortedActivities = addedActivities.sorted(by: <)
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
        startLocationDictionary["\(selectedDate)"] = locationCoordinates
    }


}

extension PlannerViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationCoordinates = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
