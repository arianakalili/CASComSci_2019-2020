//
//  ViewController.swift
//  MapMarker
//
//  Created by Riley John Gibbs on 3/22/20.
//  Copyright © 2020 Riley John Gibbs. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var crossroadsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    let CROSSROADS_LAT = 34.0240892
    let CROSSROADS_LONG = -118.4747321
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the CLLocationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Set the delegate for the MKMapView
        mapView.delegate = self
        
        // Set the initial region for the MKMapView
        let crossroadsCoord = CLLocationCoordinate2D(latitude: CROSSROADS_LAT, longitude: CROSSROADS_LONG)
        let point = MKMapPoint(crossroadsCoord)
        let size = MKMapSize(width: 1000, height: 1000)
        let rect = MKMapRect(origin: point, size: size)
        mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }

    @IBAction func zoomOut(_ sender: Any) {
        changeZoom(1)
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        changeZoom(-1)
    }
    
    func changeZoom(_ exp: Double) {
        /*
        // Uses MKMapRect to create and set region
        let factor = pow(2, exp)
        let rect = mapView.visibleMapRect
        let newSize = MKMapSize(width: rect.width * factor, height: rect.height * factor)
        let newRect = MKMapRect(origin: rect.origin, size: newSize)
        mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        */
        // Uses MKCoordinateSpan to create and set region
        let region = mapView.region
        let newLat = region.span.latitudeDelta * pow(2, exp)
        let newLong = region.span.longitudeDelta * pow(2, exp)
        let newCoordinateSpan = MKCoordinateSpan(latitudeDelta: newLat, longitudeDelta: newLong)
        let newRegion = MKCoordinateRegion(center: region.center, span: newCoordinateSpan)
        mapView.setRegion(newRegion, animated: true)
    }
    
    @IBAction func findMe(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    // MARK: Implement the MKMapViewDelegate protocol's methods
    
    // Check if we're at Crossroads right now
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let rect = mapView.visibleMapRect
        let crossroadsLoc = CLLocationCoordinate2D(latitude: CROSSROADS_LAT, longitude: CROSSROADS_LONG)
        let crossroadsPoint = MKMapPoint(crossroadsLoc)
        if rect.contains(crossroadsPoint) {
            crossroadsLabel.text = "It's Crossroads!"
        } else {
            crossroadsLabel.text = "Where's Crossroads?"
        }
    }
    
    // MARK: Implement CLLocationManagerDelegate protocol's methods
    
    // Handle new locations by moving the mapView region to the new location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = mapView.region.span
        let coords = locations.suffix(1)[0].coordinate
        let newRegion = MKCoordinateRegion(center: coords, span: span)
        mapView.setRegion(newRegion, animated: true)
    }
    
    // Handle an error when trying to get a new location by just printing the error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

