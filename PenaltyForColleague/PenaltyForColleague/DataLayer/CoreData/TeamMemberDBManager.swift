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
    
    //    func getPerson(userId: Int) -> Person? {
    //        return nil
    //    }
    
    //MARK: - TeamMember
    
    func saveTeamMember(teamMember: TeamMember) throws {
        guard let entityDescription = NSEntityDescription.personEntity() else {
            return
        }
        
        var person: Person = {
            if let id = teamMember.objectID {
                return CoreDataStack.sharedInstance.managedObjectContext.objectWithID(id) as! Person
            } else {
                return NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! Person
            }
        }()
        
        person = convertTeamMemberToPerson(teamMember, person: person) // convert as refilling
        
        try savePersonObjectInStorage(person)
        savePersonImage(teamMember)
    }
    
    func deleteTeamMember(teamMember: TeamMember) {
        let managedObjectContext = CoreDataStack.sharedInstance.managedObjectContext
        if let id = teamMember.objectID {
            let person = managedObjectContext.objectWithID(id)
            managedObjectContext.deleteObject(person)
            
            do {
                try managedObjectContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    
    func getAllTeamMembers(completion: (users: [TeamMember]) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
        fetchRequest.entity = entityDescription
        var teamMembers = [TeamMember]()
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let members = result as! [Person]
            
            for member in members {
                let teamMember = convertPersonToTeamMember(member)
                receivePhoto(teamMember)
                teamMembers.append(teamMember)
            }
            completion(users: teamMembers)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(users: teamMembers)
        }
    }
    
    //MARK: - Team
    
    func getTeamMembers(completion: (teamMembers: TeamMembers) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.teamEntity()
        fetchRequest.entity = entityDescription
        var teamMembersArray = [TeamMembers]()
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let teams = result as! [Team]
            
            for team in teams {
                let teamMember = convertTeam(team)
                teamMember.photo = receivePhoto(teamMember)
                teamMembersArray.append(teamMember)
            }
            if let teamMembers = teamMembersArray[safe: 0] {
                completion(teamMembers: teamMembers)
            } else {
                completion(teamMembers: TeamMembers())
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(teamMembers: TeamMembers())
        }
    }
    
    func saveTeam(teamMembers: TeamMembers) {
        guard let entityDescription = NSEntityDescription.teamEntity() else {
            return
        }
        
        var team: Team = {
            if let id = teamMembers.objectID {
                return CoreDataStack.sharedInstance.managedObjectContext.objectWithID(id) as! Team
            } else {
                return NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! Team
            }
        }()
        
        team = convertTeamMembers(teamMembers, toTeam: team)
        
        do {
            try saveTeamObjectInStorage(team)
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        saveTeamLogoImage(teamMembers)
    }
    
    // MARK: - Private
    
    private func savePersonImage(member: TeamMember) {
        if let imagename = member.photoName,
            let image = member.photo {
            
            let imageData = UIImageJPEGRepresentation(image, Constants.compresionQuality)
            FileSystem().saveFile(imagename, data: imageData!)
            member.photoName = imagename
        }
    }
    
    private func savePersonObjectInStorage(person: Person) throws {
        
        try person.managedObjectContext?.save()
    }
    
    private func receivePhoto(teamMember: TeamMember?) -> UIImage? {
        guard let teamMember = teamMember,
            let name = teamMember.photoName,
            let data = FileSystem().getFile(name) else {
                return nil
        }
        
        return UIImage(data: data)
    }
    
    private func receivePhoto(teamMembers: TeamMembers?) -> UIImage? {
        guard let teamMembers = teamMembers,
            let name = teamMembers.photoName,
            let data = FileSystem().getFile(name) else {
                return nil
        }
        
        return UIImage(data: data)
    }
    
    private func convertPersonToTeamMember(person: Person) -> TeamMember {
        let member = TeamMember()
        
        member.objectID = person.objectID
        member.name = person.name
        member.surname = person.surname
        member.email = person.email
        member.photoName = person.photoName
        member.photo = receivePhoto(member)
        
        return member
    }
    
    private func convertTeamMemberToPerson(member: TeamMember, person: Person) -> Person {
        person.name = member.name
        person.surname = member.surname
        person.email = member.email
        person.photoName = member.photoName
        
        return person
    }
    
    private func saveTeamObjectInStorage(managedTeam: Team) throws {
        
        try managedTeam.managedObjectContext?.save()
    }
    
    private func saveTeamLogoImage(teamMembers: TeamMembers) {
        if let imagename = teamMembers.photoName,
            let image = teamMembers.photo {
            
            let imageData = UIImageJPEGRepresentation(image, Constants.compresionQuality)
            FileSystem().saveFile(imagename, data: imageData!)
            teamMembers.photoName = imagename
        }
    }
    
    private func receivePhoto (team: Team?) -> UIImage? {
        guard let team = team,
            let name = team.photoName,
            let data = FileSystem().getFile(name) else {
                return nil
        }
        
        return UIImage(data: data)
    }
    
    private func convertTeamMembers(teamMembers: TeamMembers, toTeam team: Team) -> Team {
        team.name = teamMembers.name
        team.photoName = teamMembers.photoName
        
        return team
    }
    
    private func convertTeam(team: Team) -> TeamMembers {
        let teamMembers = TeamMembers()
        
        teamMembers.objectID = team.objectID
        teamMembers.name = team.name
        teamMembers.photoName = team.photoName
        
        return teamMembers
    }
}