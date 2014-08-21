//
//  ReminderViewController.swift
//  Week5-B19
//
//  Created by Leonardo Lee on 8/20/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class ReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var reminderTableView: UITableView!
	var reminderFetchResults : NSFetchedResultsController!
	var reminders = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
//MARK: - Delegates
//MARK: UITableViewDataSource
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return reminderFetchResults.sections[section].numberOfObjects
	}
	func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
		var cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as UITableViewCell
		configureCell(cell, forIndexPath: indexPath)
		
		return cell
	}
	func configureCell(cell: UITableViewCell, forIndexPath: NSIndexPath) {
		
	}


}
