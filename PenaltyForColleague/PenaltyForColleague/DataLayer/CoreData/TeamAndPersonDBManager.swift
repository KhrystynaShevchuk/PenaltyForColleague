//
//  CoreDataObject.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/20/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class TeamAndPersonDBManager {
    
    static var sharedInstance = TeamAndPersonDBManager()
    
    //MARK: - Puplic Person
    
    func savePerson(person: Person, completion:(success: Bool)->()) {
        guard let entityDescription = NSEntityDescription.personEntity() else {
            completion(success: false)
            return
        }
        
        getManagedPerson(entityDescription, id: person.id) { (managedPerson) in
            let saveManagedPerson = managedPerson.updateManagedPerson(managedPerson, withPerson: person)
            self.savePersonObjectInStorage(saveManagedPerson)
            self.savePersonImage(person)
            
            completion(success: true)
        }
        
    }
    
    func deletePerson(person: Person) {
        if person.id.isEmpty {
            return
        }
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.personEntity()
        fetchRequest.entity = entityDescription
        var managedPersons = [ManagedPerson]()
        do {
            managedPersons = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedPerson]
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        for mPerson in managedPersons {
            if person.id == mPerson.personId {
                deletePersonObjectFromStorage(mPerson)
            }
        }
    }
    
    func getAllPersons(completion: (persons: [Person]) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.personEntity()
        fetchRequest.entity = entityDescription
        var persons = [Person]()
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let members = result as! [ManagedPerson]
            
            for member in members {
                let person = Person.updatePersonWith(managedPerson: member)
                if let photoName = person.photoName {
                    receivePhoto(photoName)
                }
                
                persons.append(person)
            }
            
            completion(persons: persons)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(persons: persons)
        }
    }
    
    // MARK: - Private Person
    
    private func getManagedPerson(entityDescription:NSEntityDescription, id: String, completion: (managedPerson: ManagedPerson) -> ()) {
        getPersonForSave(id) { (managedPerson) in
            if let person = managedPerson {
                completion(managedPerson: person)
            }
            else {
                let newPerson = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedPerson
                
                completion(managedPerson: newPerson)
            }
        }
    }
    
    private func getPersonForSave(id: String, completion: (managedPerson: ManagedPerson?) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.personEntity()
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "personId = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let members = result as! [ManagedPerson]
            
            guard let member = members.first else {
                completion(managedPerson: nil)
                return
            }
            
            completion(managedPerson: member)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(managedPerson: nil)
        }
    }
    
    private func savePersonObjectInStorage(managedPerson: ManagedPerson) {
        
        do {
            try managedPerson.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
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
    
    private func deletePersonObjectFromStorage(managedPerson: ManagedPerson) {
        CoreDataStack.sharedInstance.managedObjectContext.deleteObject(managedPerson)
        do {
            try CoreDataStack.sharedInstance.managedObjectContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    //MARK: - Public Team

    
    func saveTeam(team: Team, completion:(success: Bool)->()) {
        guard let entityDescription = NSEntityDescription.teamEntity() else {
            completion(success: false)
            return
        }
        
        getManagedTeam(entityDescription, id: team.id) { (managedTeam) in
            let saveManagedTeam = managedTeam.updateManagedTeam(managedTeam, withTeam: team)
            self.saveTeamObjectInStorage(saveManagedTeam)
            self.saveTeamLogoImage(team)
            
            completion(success: true)
        }
    }
    
    func getCurrentTeam(team: Team) -> Team {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.teamEntity()
        fetchRequest.entity = entityDescription
        var managedTeams = [ManagedTeam]()
        
        do {
            managedTeams = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedTeam]
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        let managedTeam = managedTeams.first
        var currentTeam = Team()

        if let mTeam = managedTeam {
            currentTeam = team.updateTeamWith(managedTeam: mTeam)
        }
        
        return currentTeam
    }
    
    // MARK: - Private for Team
    
    private func getManagedTeam(entityDescription: NSEntityDescription, id: String, completion: (managedTeam: ManagedTeam) -> ()) {
        getTeamForSave(id) { (managedTeam) in
            if let team = managedTeam {
                completion(managedTeam: team)
            } else{
                let newTeam = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedTeam
                completion(managedTeam: newTeam)
            }
        }
    }
    
    private func getTeamForSave(id: String, completion: (managedTeam: ManagedTeam?) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.teamEntity()
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "teamId = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let managedTeams = result as! [ManagedTeam]
            
            guard let team = managedTeams.first else {
                completion(managedTeam: nil)
                return
            }
            completion(managedTeam: team)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(managedTeam: nil)
        }
    }
    
    private func saveTeamObjectInStorage(managedTeam: ManagedTeam) {
        
        do {
            try managedTeam.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    private func saveTeamLogoImage(team: Team) {
        if let imagename = team.photoName,
            let image = team.photo {
            
            let imageData = UIImageJPEGRepresentation(image, Constants.compresionQuality)
            FileSystem().saveFile(imagename, data: imageData!)
            team.photoName = imagename
        }
    }
    
    
    // MARK: - Receive photo
    
    func receivePhoto(photoName: String) -> UIImage? {
        guard let data = FileSystem().getFile(photoName) else {
            return nil
        }
        
        return UIImage(data: data)
    }
}