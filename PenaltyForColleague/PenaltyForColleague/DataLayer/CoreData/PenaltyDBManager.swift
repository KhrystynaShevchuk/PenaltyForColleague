//
//  PenaltyDBManager.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/25/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class PenaltyDBManager {
    
    static var sharedInstance = PenaltyDBManager()
    
    // MARK: - Public
    
    func savePenalty(penalty: Penalty) throws {
        
        guard let entityDescription = NSEntityDescription.penaltyEntity() else {
            return
        }
        
        var managedPenalty: ManagedPenalty = {
            if let id = penalty.objectID {
                return CoreDataStack.sharedInstance.managedObjectContext.objectWithID(id) as! ManagedPenalty
            } else {
                return NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedPenalty
            }
        }()
        
        managedPenalty = convertPenalty(penalty, toManagedPenalty: managedPenalty)
        
        do {
            try savePenaltyObjectInStorage(managedPenalty)
        } catch {
            let savedError = error as NSError
            print(savedError)
        }
        
    }
    
    func getAllPenalties(completion: (penalties: [Penalty]) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.penaltyEntity()
        fetchRequest.entity = entityDescription
        var penalties = [Penalty]()
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let managedPenalties = result as! [ManagedPenalty]
            
            for managedPenalty in managedPenalties {
                let penalty = convertManagedPenaltyToPenalty(managedPenalty)
                penalties.append(penalty)
            }
            completion(penalties: penalties)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(penalties: penalties)
        }
    }
    
    func deletePenalty(penalty: Penalty) {
        let managedObjectContext = CoreDataStack.sharedInstance.managedObjectContext
        if let id = penalty.objectID {
            let managedPenalty = managedObjectContext.objectWithID(id)
            managedObjectContext.deleteObject(managedPenalty)
            
            do {
                try managedObjectContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    
    // MARK: - PRIVATE
    
    private func savePenaltyObjectInStorage(managedPenalty: ManagedPenalty) throws {
        
        do {
            try managedPenalty.managedObjectContext?.save()
        } catch {
            let savedError = error as NSError
            print(savedError)
        }
    }
    
    private func convertManagedPenaltyToPenalty(managedPenalty: ManagedPenalty) -> Penalty {
        let penalty = Penalty()
        
        penalty.objectID = managedPenalty.objectID
        penalty.penaltyDescription = managedPenalty.penalty
        
        return penalty
    }
    
    private func convertPenalty(penalty: Penalty, toManagedPenalty managedPenalty: ManagedPenalty) -> ManagedPenalty {
        managedPenalty.penalty = penalty.penaltyDescription
        
        return managedPenalty
    }
}
