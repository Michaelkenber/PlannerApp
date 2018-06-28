//
//  MapViewController.swift
//  PlannerApp
//
// Change map location
//
//  Created by Michael Berend on 14/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
//  This is the viewcontroller that represents the map with the daily activities and the corresponding route as a polyline.

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Location {
    case startLocation
    case destinationLocation
}

class MapViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart: Coordinate!
    var locationEnd: Coordinate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        

        // set camera at startlocation
        let camera = GMSCameraPosition.camera(withLatitude: (startLocationDictionary[selectedDate]?.latitude)!, longitude: (startLocationDictionary[selectedDate]?.longitude)!, zoom: 4.0)
        

        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true             // enable user location
        self.googleMaps.settings.myLocationButton = true        // enable user location button
        self.googleMaps.settings.compassButton = true           // enable compass button
        self.googleMaps.settings.zoomGestures = true           // enable zoom
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        googleMaps.clear()
        
        // get locations from the sorted activities, not from the travel types
        if let dailyActivities = dateDictionary[selectedDate] {
            var activities = [Activity]()
            let sortedActivities = dailyActivities.sorted(by: <)
            for activity in sortedActivities {
                if activity.type == "Activity" {
                    activities.append(activity)
                }
            }
            
            // draw paths between activities and place markes
            if activities.count > 1 {
                for index in 0...(activities.count - 2) {
                    drawPath(startLocation: activities[index].coordinates, endLocation: activities[index + 1].coordinates, transport: activities[index + 1].transport)
                    createMarker(titleMarker: activities[index].activity, iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: activities[index].coordinates.latitude, longitude: activities[index].coordinates.longitude, snippet: "\(activities[index].timeString) - \(activities[index].endTimeString)")
                }
            }
            
            // determine route from start location to first activity, and place markers
            if activities.count > 0 {
                let startLocation = startLocationDictionary[selectedDate]
                createMarker(titleMarker: "Start location", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: (startLocation?.latitude)!, longitude: (startLocation?.longitude)!, snippet: "Have a nice start of your day")
                let camera = GMSCameraPosition.camera(withLatitude: (activities.first?.coordinates.latitude)!, longitude: (activities.first?.coordinates.longitude)!, zoom: 10.0)
                self.googleMaps?.animate(to: camera)
                drawPath(startLocation: (startLocation)!, endLocation: activities[0].coordinates, transport: activities[0].transport)
                if activities.count == 1 {
                    createMarker(titleMarker: activities[0].activity, iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: activities[0].coordinates.latitude, longitude: activities[0].coordinates.longitude, snippet: "\(activities[0].timeString) - \(activities[0].endTimeString)")
                }
            }
        }
    }
    
    /// Function to create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees, snippet: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
        marker.snippet = snippet
    }
    
    /// Enable current location
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
    /// Unselect marker if map is moved
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    
    
  
    /// draw a path between two given locations
    func drawPath(startLocation: Coordinate, endLocation: Coordinate, transport: String)
    {
        //  Code created in part by https://stackoverflow.com/questions/22550849/drawing-route-between-two-places-on-gmsmapview-in-ios/35045733
        
        // define start and end
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        // define url
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDs9-PYsYSVlhHhZJFJ-jyLZ9azoyA1oSY"
        
        // retrieve the routes from google directions api
        Alamofire.request(url).responseJSON { response in

            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                print("\(routes)")
                
                // print route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.googleMaps
                }
            } catch {
                print(error)
            }
        }
    }
}
