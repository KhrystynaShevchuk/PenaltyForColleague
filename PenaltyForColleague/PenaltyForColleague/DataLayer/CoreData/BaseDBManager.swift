//
//  BaseDBManager.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/28/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class BaseDBManager {
    
    func saveItem(entity: NSEntityDescription, predicate: NSPredicate, completion: (object: NSManagedObject?) -> ()) {
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let objects = result as! [NSManagedObject]
            
            guard let object = objects.first else {
                completion(object: nil)
                return
            }
            completion(object: object)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(object: nil)
        }
    }
    
    func saveObjectInStorage(managedObject: NSManagedObject) {
        
        do {
            try managedObject.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    func getAllItems(entity: NSEntityDescription, completion: (objects: [NSManagedObject]) -> ()) {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        do {
            let managedObjects = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            if let objects = managedObjects as? [NSManagedObject] {
                completion(objects: objects)
            }
        } catch {
            _ = error as NSError
            completion(objects: [])
        }
    }

    func deleteItem(entity: NSEntityDescription, predicate: NSPredicate, completion:(success: Bool)->()) {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate

        do {
            let managedObjects = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            if let managedObject = managedObjects.first as? NSManagedObject {
                CoreDataStack.sharedInstance.managedObjectContext.deleteObject(managedObject)
                do {
                    try CoreDataStack.sharedInstance.managedObjectContext.save()
                    completion(success: true)
                } catch {
                    _ = error as NSError
                    completion(success: false)
                }
            }
            else {
                completion(success: false)
            }
        } catch {
            let saveError = error as NSError
            print(saveError)
            completion(success: false)
        }
    }
}