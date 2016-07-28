//
//  TeamDBManager.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/28/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class TeamDBManager: BaseDBManager {
    
    //MARK: - Public Team
    
    func saveTeam(team: Team, completion:(success: Bool)->()) {
        guard let entityDescription = NSEntityDescription.teamEntity() else {
            completion(success: false)
            return
        }
        
        saveWith(entityDescription: entityDescription, id: team.id) { (managedTeam) in
            
            guard let mTeam = managedTeam else {
                completion(success: false)
                return
            }
            let saveManagedTeam = mTeam.updateManagedTeam(mTeam, withTeam: team)
        
            self.saveObjectInStorage(saveManagedTeam as NSManagedObject)
            self.saveTeamLogoImage(team)
            
            completion(success: true)
        }
    }

    func getCurrentTeam(team: Team) -> Team {
        guard let entityDescription = NSEntityDescription.teamEntity() else {
            return Team()
        }
        var currentTeam = Team()
        
        getAllItems(entityDescription) { (objects) in
            guard let managedTeam = objects.first as? ManagedTeam else {
                return
            }
            
            currentTeam = team.updateTeamWith(managedTeam: managedTeam)
        }
        
        return currentTeam
    }
    
    // MARK: - Private
    
    private func saveWith(entityDescription entityDescription: NSEntityDescription, id: String, completion:(managedTeam: ManagedTeam?)->()) {
        
        let predicate = NSPredicate(format: "teamId = %@", id)
        
        saveItem(entityDescription, predicate: predicate) { (object) in
            guard let managedTeam = object as? ManagedTeam else {
                
                let newTeam = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedTeam
                
                completion(managedTeam: newTeam)
                return
            }
            completion(managedTeam: managedTeam)
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
}