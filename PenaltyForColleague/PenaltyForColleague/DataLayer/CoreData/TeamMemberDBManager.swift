//
//  CoreDataObject.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/20/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class TeamMemberDBManager {
    
    static var sharedInstance = TeamMemberDBManager()
    
    //    func getPerson(userId: Int) -> ManagedPerson? {
    //        return nil
    //    }
    
    //MARK: - Puplic for Person
    
    func savePerson(person: Person) throws {
        guard let entityDescription = NSEntityDescription.personEntity() else {
            return
        }
        
        var managedPerson: ManagedPerson = {
            if let id = person.objectID {
                return CoreDataStack.sharedInstance.managedObjectContext.objectWithID(id) as! ManagedPerson
            } else {
                return NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedPerson
            }
        }()
        
        managedPerson = convertPersonToManagedPerson(person, managedPerson: managedPerson) // convert as refilling
        
        try savePersonObjectInStorage(managedPerson)
        savePersonImage(person)
    }
    
    func deletePerson(person: Person) {
        let managedObjectContext = CoreDataStack.sharedInstance.managedObjectContext
        if let id = person.objectID {
            let managedPerson = managedObjectContext.objectWithID(id)
            managedObjectContext.deleteObject(managedPerson)
            
            do {
                try managedObjectContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
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
                let person = convertManagedPersonToPerson(member)
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
    
    //MARK: - Public for Team
    
    func getTeam(completion: (team: Team) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.teamEntity()
        fetchRequest.entity = entityDescription
        var teamsArray = [Team]()
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let managedTeam = result as! [ManagedTeam]
            
            for team in managedTeam {
                let team = convertManagedTeamToTeam(team)
                if let photoName = team.photoName {
                    team.photo = receivePhoto(photoName)
                }
                teamsArray.append(team)
            }
            if let teams = teamsArray[safe: 0] {
                completion(team: teams)
            } else {
                completion(team: Team())
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(team: Team())
        }
    }
    
    func saveTeam(team: Team) {
        guard let entityDescription = NSEntityDescription.teamEntity() else {
            return
        }
        
        var managedTeam: ManagedTeam = {
            if let id = team.objectID {
                return CoreDataStack.sharedInstance.managedObjectContext.objectWithID(id) as! ManagedTeam
            } else {
                return NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedTeam
            }
        }()
        
        managedTeam = convertTeamMembers(team, toManagedTeam: managedTeam)
        
        do {
            try saveTeamObjectInStorage(managedTeam)
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        saveTeamLogoImage(team)
    }
    
    // MARK: - Private for Person
    
    private func savePersonImage(person: Person) {
        if let imagename = person.photoName,
            let image = person.photo {
            
            let imageData = UIImageJPEGRepresentation(image, Constants.compresionQuality)
            FileSystem().saveFile(imagename, data: imageData!)
            person.photoName = imagename
        }
    }
    
    private func savePersonObjectInStorage(managedPerson: ManagedPerson) throws {
        
        try managedPerson.managedObjectContext?.save()
    }
    
    private func convertManagedPersonToPerson(managedPerson: ManagedPerson) -> Person {
        let person = Person()
        
        person.objectID = managedPerson.objectID
        person.name = managedPerson.name
        person.surname = managedPerson.surname
        person.email = managedPerson.email
        person.photoName = managedPerson.photoName
        if let photoName = person.photoName {
            person.photo = receivePhoto(photoName)
        }
        return person
    }
    
    private func convertPersonToManagedPerson(person: Person, managedPerson: ManagedPerson) -> ManagedPerson {
        managedPerson.name = person.name
        managedPerson.surname = person.surname
        managedPerson.email = person.email
        managedPerson.photoName = person.photoName
        
        return managedPerson
    }
    
    // MARK: - Private for Team
    
    private func saveTeamObjectInStorage(managedTeam: ManagedTeam) throws {
        
        try managedTeam.managedObjectContext?.save()
    }
    
    private func saveTeamLogoImage(team: Team) {
        if let imagename = team.photoName,
            let image = team.photo {
            
            let imageData = UIImageJPEGRepresentation(image, Constants.compresionQuality)
            FileSystem().saveFile(imagename, data: imageData!)
            team.photoName = imagename
        }
    }
    
    private func convertTeamMembers(team: Team, toManagedTeam managedTeam: ManagedTeam) -> ManagedTeam {
        managedTeam.name = team.name
        managedTeam.photoName = team.photoName
        
        return managedTeam
    }
    
    private func convertManagedTeamToTeam(managedTeam: ManagedTeam) -> Team {
        let team = Team()
        
        team.objectID = managedTeam.objectID
        team.name = managedTeam.name
        team.photoName = managedTeam.photoName
        
        return team
    }
    
    // MARK: - Common private funcs
    
    private func receivePhoto(photoName: String) -> UIImage? {
        guard let data = FileSystem().getFile(photoName) else {
            return nil
        }
        
        return UIImage(data: data)
    }
}