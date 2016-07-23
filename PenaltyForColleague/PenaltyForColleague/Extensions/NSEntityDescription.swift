//
//  NSEntityDescription.swift
//  PenaltyForColleague
//
//  Created by Khrystyna Shevchuk on 7/19/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import CoreData

extension NSEntityDescription {
    
    class func personEntity(managedObjectContext: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext) -> NSEntityDescription? {
        return entityForName("Person", context: managedObjectContext)
    }
    
    class func teamEntity(managedObjectContext: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext) -> NSEntityDescription? {
        return entityForName("Team", context: managedObjectContext)
    }
    
    class func entityForName(name: String, context: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(name, inManagedObjectContext: context)
    }
}
