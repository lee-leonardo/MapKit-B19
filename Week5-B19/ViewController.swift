//
//  ViewController.swift
//  Week5-B19
//
//  Created by Leonardo Lee on 8/18/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var latitudeField: UITextField!
	@IBOutlet weak var longitudeField: UITextField!
	
	var locationManager = CLLocationManager()
	
//MARK:
//MARK: View methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		
		self.mapView = MKMapView(frame: self.mapView.frame)
		
		var startCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
		var region = MKCoordinateRegionMake(startCoordinate, MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
		self.mapView.setRegion(region, animated: true)

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
//MARK:
//MARK: CLLocation
	func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		switch status {
		case .Authorized:
			println("didChangeAuthorizationStatus - Authorized")
			locationManager.startUpdatingLocation()

			//Apple's low power version
			//locationManager.startMonitoringSignificantLocationChanges()
			
		case .AuthorizedWhenInUse:
			println("didChangeAuthorizationStatus - Authorized in use")
			locationManager.startUpdatingLocation()
			
			//.startMonitoringSignificantLocationChanges() Isn't performant enough to really use the when in use.
			
		case .Denied, .Restricted:
			println("didChangeAuthorizationStatus - Denied or Restricted")
		case .NotDetermined:
			println("didChangeAuthorizationStatus - Not determined")
			locationManager.requestWhenInUseAuthorization()
			//locationManager.requestAlwaysAuthorization()
		}
	}

	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		println("locationManager: \(manager) currentLocation: \(locations.last)")
		
	}
	
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		println("locationManager: \(manager) failed with error: \(error)")
	}
	
//MARK:
//MARK: IBAction
	@IBAction func markCoordinate(sender: AnyObject) {
		
	}
}

