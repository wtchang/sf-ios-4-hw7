//
//  ViewController.swift
//  iOS4-hw7-jsonmaps
//
//  Created by Kathryn Rotondo on 2/27/16.
//  Copyright © 2016 Kathryn Rotondo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var pins:[Pin] = []
    let endpoint = "http://kathrynrotondo.com/ios4/pins.json"
    
    let latitude:CLLocationDegrees = 37.77
    let longitude:CLLocationDegrees = -122.45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // centers map on San Francisco
        centerMapOnLocation(latitude, longitude: longitude)
        
        loadData(endpoint)
        
        // adds a sample pin
        let pin = Pin(title: "GA", latitude: 37.7908727, longitude: -122.4034906)
        pins.append(pin)
        
        loadPins()
    }
    
    func loadData(urlString:String){
        if let url = NSURL(string: urlString) {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                if let data = try? NSData(contentsOfURL: url, options: []){
                    print("We got data")
                    let json = JSON(data: data)
                    self.parseData(json)
                }
            }
        }
    }
    
    func parseData(json:JSON){
        for result in json["Pins"].arrayValue{
            let name = result["name"].stringValue
            let coordinates = result["coordinates"]
            let latitude = coordinates["latitude"].doubleValue
            let longitude = coordinates["longitude"].doubleValue
            let pin = Pin(title: name, latitude: latitude, longitude: longitude)
           pins.append(pin)
        }
        loadPins()
    }
    
    func loadPins(){
        for pin in pins {
            addAnnotation(pin)
        }
    }


    func centerMapOnLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        // gets the center point
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        // gets the zoom
        let radius:CLLocationDistance = 18000 // in meters
        
        // creates a region showing center at zoom and sets it on map
        let region = MKCoordinateRegionMakeWithDistance(coordinate, radius, radius)
        map.setRegion(region, animated: true)
    }

    
    func addAnnotation(pin:Pin) {
        
        // creates an MKPointAnnotation
        let annotation:MKPointAnnotation = MKPointAnnotation()
        
        // sets its properties
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        annotation.coordinate = coordinate
        annotation.title = pin.title
        
        // adds it to the map
        map.addAnnotation(annotation)
    }
}