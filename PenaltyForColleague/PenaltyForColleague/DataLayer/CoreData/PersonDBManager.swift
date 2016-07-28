//
//  CoreDataObject.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/20/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class PersonDBManager: BaseDBManager {
        
    //MARK: - Puplic
    
    func savePerson(person: Person, completion:(success: Bool)->()) {
        guard let entityDescription = NSEntityDescription.personEntity() else {
            completion(success: false)
            return
        }
        
        saveWith(entityDescription: entityDescription, id: person.id) { (managedPerson) in
            
            guard let mPerson = managedPerson else {
                completion(success: false)
                return
            }
            let saveManagedPerson = mPerson.updateManagedPerson(mPerson, withPerson: person)
            
            self.saveObjectInStorage(saveManagedPerson as NSManagedObject)
            self.savePersonImage(person)
                
            completion(success: true)
        }
    }
    
    func getAllPersons(completion: (persons: [Person]) -> ()) {
        
        guard let entityDescription = NSEntityDescription.personEntity() else {
            completion(persons: [])
            return
        }
        
        var persons = [Person]()
        
        getAllItems(entityDescription) { (objects) in
            guard let managedPersons = objects as? [ManagedPerson] else {
                completion(persons: [])
                return
            }
            for managedPerson in managedPersons {
                let person = Person.updatePersonWith(managedPerson: managedPerson)
                if let photoName = person.photoName {
                    person.photo = UIImage.receivePhoto(photoName)
                }
                persons.append(person)
            }
            completion(persons: persons)
        }
    }
    
    func deletePerson(person: Person) {
        if person.id.isEmpty {
            return
        }
        
        guard let entityDescription = NSEntityDescription.personEntity() else {
            return
        }
        
        let predicate = NSPredicate(format: "personId = %@", person.id)
        deleteItem(entityDescription, predicate: predicate) { (success) in
            
        }
    }
    
    // MARK: - Private
    
    private func saveWith(entityDescription entityDescription: NSEntityDescription, id: String, completion:(managedPerson: ManagedPerson?)->()) {
        
        let predicate = NSPredicate(format: "personId = %@", id)
        
        saveItem(entityDescription, predicate: predicate) { (object) in
            guard let managedPerson = object as? ManagedPerson else {
                
                let newPerson = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedPerson
                
                completion(managedPerson: newPerson)
                return
            }
            completion(managedPerson: managedPerson)
        }
    }
    
    private func savePersonImage(person: Person) {
        if let imagename = person.photoName,
            let image = person.photo {
            
            let imageData = UIImageJPEGRepresentation(image, Constants.compresionQuality)
            FileSystem().saveFile(imagename, data: imageData!)
            person.photoName = imagename
        }
    }
}