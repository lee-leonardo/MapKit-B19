//
//  Reminder.swift
//  Week5-B19
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var message: String

}
