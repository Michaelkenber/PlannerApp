//
//  MapViewController.swift
//  PlannerApp
//
// Change map location
//
//  Created by Michael Berend on 14/06/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//
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
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        

        //Your map initiation code
        let camera = GMSCameraPosition.camera(withLatitude: 52.0907, longitude: 5.1214, zoom: 4.0)
        
        print(camera)

        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        googleMaps.clear()
        if let dailyActivities = dateDictionary[selectedDate] {
            var locations = [CLLocation]()
            let sortedActivities = dailyActivities.sorted(by: <)
            for activity in sortedActivities {
                locations.append(activity.coordinates)
            }
            if locations.count > 1 {
                for index in 0...(locations.count - 2) {
                    drawPath(startLocation: locations[index], endLocation: locations[index + 1])
                    createMarker(titleMarker: sortedActivities[index].activity, iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: locations[index].coordinate.latitude, longitude: locations[index].coordinate.longitude)
                }
            }
            if locations.count > 0 {
                let startLocation = startLocationDictionary[selectedDate]
                createMarker(titleMarker: "Start location", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: (startLocation?.coordinate.latitude)!, longitude: (startLocation?.coordinate.longitude)!)
                let camera = GMSCameraPosition.camera(withLatitude: (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!, zoom: 10.0)
                self.googleMaps?.animate(to: camera)
                drawPath(startLocation: (startLocation)!, endLocation: locations[0])
                if locations.count == 1 {
                    createMarker(titleMarker: sortedActivities[0].activity, iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
                }
            }
        }
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDs9-PYsYSVlhHhZJFJ-jyLZ9azoyA1oSY"
        
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

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
