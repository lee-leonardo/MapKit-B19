//
//  ViewController.swift
//  Week5-B19
//
//  Created by Leonardo Lee on 8/18/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

	@IBOutlet var theMapView: MKMapView!
	@IBOutlet weak var latitudeField: UITextField!
	@IBOutlet weak var longitudeField: UITextField!
	
	var locationManager = CLLocationManager()
	
//MARK:
//MARK: View methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.locationManager.delegate = self
		self.theMapView.delegate = self
		
		self.locationManager.requestWhenInUseAuthorization()
		
		
//		var startCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//		var region = MKCoordinateRegionMake(startCoordinate, MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
//		self.theMapView.setRegion(region, animated: true)

	}
	override func viewWillAppear(animated: Bool) {
	}
	override func viewWillDisappear(animated: Bool) {
		locationManager.stopUpdatingLocation()
		locationManager.stopMonitoringSignificantLocationChanges()
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
			
//			if CLLocationManager.locationServicesEnabled() {
//				locationManager.startUpdatingLocation()
//				locationManager.desiredAccuracy = Double(10)
//				locationManager.distanceFilter = Double(100)
			self.theMapView.showsUserLocation = true

//			}
			if CLLocationManager.significantLocationChangeMonitoringAvailable() {
				locationManager.startMonitoringSignificantLocationChanges() //Apple's low power version
			}
			
		case .AuthorizedWhenInUse:
			println("didChangeAuthorizationStatus - Authorized in use")
			//locationManager.startUpdatingLocation()
			locationManager.startMonitoringSignificantLocationChanges() //Isn't performant enough to really use the when in use.
			self.theMapView.showsUserLocation = true

			
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
		
//		var newCoordinate = latitude: self.latitudeField.text.doubleValue, longitude: string: self.longitudeField.text.doubleValue)
//		var region = MKCoordinateRegionMake(newCoordinate, MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
//		self.theMapView.setRegion(region, animated: true)
		
		
	}
}

