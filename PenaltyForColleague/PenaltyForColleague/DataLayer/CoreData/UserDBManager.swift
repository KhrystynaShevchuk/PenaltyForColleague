//
//  CoreDataObject.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/20/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class UserDBManager {
    
    func getPerson(userId: Int) -> Person? {
        return nil
    }
    
    func savePersonData(person: TeamMember) {
        guard let entityDescription = NSEntityDescription.personEntity() else {
            return
        }
        
        var newPerson = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! Person
        newPerson = convertTeamMemberToPerson(person, newPerson: newPerson)
        
        savePersonObjectInStorage(newPerson)
        savePersonImage(person)
    }
    
    func deletePerson(person: Person) {
    
    }
    
    func getAllUsers(completion: (users: [TeamMember]?) -> ()){
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
        fetchRequest.entity = entityDescription

        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let members = result as! [Person]
            var teamMembers = [TeamMember]()
            for member in members {
                let teamMember = convertPersonToTeamMember(member)
                receivePhoto(teamMember)
                teamMembers.append(teamMember)
            }
            completion(users: teamMembers)
        
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(users: nil)
        }
    }
    
    // MARK: - Private
    
    func savePersonImage(member: TeamMember) {
        if let imagename = member.photoName, let image = member.photo {
            
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            FileSystem().saveFile(imagename, data: imageData!)
            member.photoName = imagename
        }
    }
    
    private func savePersonObjectInStorage(newPerson: Person){
        do {
            try newPerson.managedObjectContext?.save()
        } catch {
            print(error)
            let alert = UIAlertController(title: "Error", message: "Data weren't saved.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            AddTeamMemberVC().presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func receivePhoto (person: TeamMember?) -> UIImage? {
        guard let person = person else {
            return nil
        }
        
        guard let name = person.photoName else {
            return nil
        }
        
        if let data = FileSystem().getFile(name) {
            let image = UIImage(data: data)
            return image
        } else {
            return nil
        }
    }
    
    private func convertPersonToTeamMember(person: Person) -> TeamMember {
        let member = TeamMember()
        member.name = person.name
        member.surname = person.surname
        member.email = person.email
        member.photoName = person.photoName
        member.photo = receivePhoto(member)
        
        return member
    }
    
    private func convertTeamMemberToPerson(member: TeamMember, newPerson: Person) -> Person {
        newPerson.name = member.name
        newPerson.surname = member.surname
        newPerson.email = member.email
        newPerson.photoName = member.photoName
        
        return newPerson
    }
}