//
//  ViewController.swift
//  Week5-B19
//
//  Created by Leonardo Lee on 8/18/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

	@IBOutlet var theMapView: MKMapView!
	@IBOutlet weak var latitudeField: UITextField!
	@IBOutlet weak var longitudeField: UITextField!
	
	var locationManager = CLLocationManager()
	var reminderContext : NSManagedObjectContext!
	var reminderFetchResultController : NSFetchedResultsController!
	var reminders = [Reminder]()
	
	
//MARK:
//MARK: View methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.locationManager.delegate = self
		self.theMapView.delegate = self
		
		self.locationManager.requestWhenInUseAuthorization()
		
		//Set up Core Data
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.reminderContext = appDelegate.managedObjectContext
		self.setupCoreData()
		
//		var startCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//		var region = MKCoordinateRegionMake(startCoordinate, MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
//		self.theMapView.setRegion(region, animated: true)
		
		//AddLongPress and a mapPressedMethod
		//var longPress = UILongPressGestureRecognizer(target: self.theMapView, action: "mapPressed:")
		

	}
	override func viewWillDisappear(animated: Bool) {
		locationManager.stopUpdatingLocation()
		locationManager.stopMonitoringSignificantLocationChanges()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
//MARK: Segue
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "ShowReminders" {
			let destination = segue.destinationViewController as ReminderViewController
			destination.reminderFetchResults = self.reminderFetchResultController
		}
	}
	
//MARK: CoreData
	func setupCoreData() {
		var request = NSFetchRequest(entityName: "Reminder")
		let sort = NSSortDescriptor(key: "message", ascending: true)
		request.sortDescriptors = [sort]
		//request.fetchBatchSize = 20
		
		self.reminderFetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: reminderContext, sectionNameKeyPath: nil, cacheName: nil) //Implement keypath and cacheName
		self.reminderFetchResultController.delegate = self
		
	}
	
	func addReminder(coordinates: CLLocationCoordinate2D) {
		var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.reminderContext) as Reminder
		newReminder.latitude = coordinates.latitude
		newReminder.longitude = coordinates.longitude
		newReminder.message = "n/a"
		
		var error : NSError?
		self.reminderContext.save(&error)
		
		if error != nil {
			println(error?.localizedDescription)
		}
		
		
	}
	
//MARK: - CLLocation
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
	
//MARK: CLLocationManagerDelegate
	
	
//MARK: - MKMapViewDelegate
//	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		//like tableViewCells
		
		//refactor into a subroutine.
//		var annotationView = MKAnnotationView()
//		if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin") as? MKPinAnnotationView {
//			
//		} else {
//			
//		}
//		
//		if annotationView == nil {
//			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin") //ReuseID set here not on SB
//
//		}
//		annotationView.animatesDrop = true
//		annotationView.canShowCallout = true
		
//		var rButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
//		annotationView.rightCalloutAccessoryView = rButton
		
//		return annotationView
//	}
	
	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
		//Tells which accessory was clicked.
		
		var annotation = view.annotation
		annotation.coordinate //to set up region to monitor.
		
		//var createdRegion = CLCircularRegion(center: annotation.coordinate, radius: 200, identifier: "Reminder")
		//self.locationManager.startMonitoringForRegion(createdRegion) //CLCircularRegion is preferred now.\
		
		println(annotation.coordinate.latitude)
		println(annotation.coordinate.longitude)

	}
	
	func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
		println("did enter region")
	}
	
	func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
		println("did leave region")
	}
	
//MARK: - IBAction
	@IBAction func markCoordinate(sender: AnyObject) {
		
		var latitude : NSString = self.latitudeField.text
		var longitude : NSString = self.longitudeField.text

		var setCoordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)

		var pin = MKPointAnnotation()
		pin.coordinate = setCoordinate
		
		self.addReminder(setCoordinate)
		
		theMapView.addAnnotation(pin)
	}
	
	
	@IBAction func showReminders(sender: AnyObject) {
		self.performSegueWithIdentifier("ShowReminders", sender: self)
	}
	
	func mapPressed(sender: UILongPressGestureRecognizer) {
		switch sender.state {
		case .Began:
			println("Began")
			var touchPoint = sender.locationInView(self.theMapView)
			var touchCoordinate = self.theMapView.convertPoint(touchPoint, toCoordinateFromView: self.theMapView)
			
			var annotation = MKPointAnnotation()
			annotation.coordinate = touchCoordinate
			annotation.title = "Add Reminder"
			
			self.theMapView.addAnnotation(annotation)
		case .Changed:
			println()

		default:
			println("Lol")
		}
	}
	
}

