//
//  PenaltyDBManager.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/25/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class PenaltyDBManager: BaseDBManager {
    
    // MARK: - Public
    
    func savePenalty(penalty: Penalty, completion: (success: Bool) -> ()) {
        guard let entityDescription = NSEntityDescription.penaltyEntity() else {
            completion(success: false)
            return
        }
        
        saveWith(entityDescription: entityDescription, id: penalty.id) { (managedPenalty) in
            
            guard let mPenalty = managedPenalty else {
                completion(success: false)
                return
            }
            let saveManagedPenalty = mPenalty.updateManagedPenalty(mPenalty, withPenalty: penalty)
            
            self.saveObjectInStorage(saveManagedPenalty as NSManagedObject)
            
            completion(success: true)
        }
    }
    
    func getAllPenalties(completion: (penalties: [Penalty]) -> ()) {
        
        guard let entityDescription = NSEntityDescription.penaltyEntity() else {
            completion(penalties: [])
            return
        }
        
        var penalties = [Penalty]()
        
        getAllItems(entityDescription) { (objects) in
            guard let managedPenalties = objects as? [ManagedPenalty] else {
                completion(penalties: [])
                return
            }
            for managedPenalty in managedPenalties {
                let penalty = Penalty.updatePenaltyWith(managedPenalty: managedPenalty)
                
                penalties.append(penalty)
            }
            completion(penalties: penalties)
        }
    }

    func deletePenalty(penalty: Penalty) {
        if penalty.id.isEmpty {
            return
        }
        
        guard let entityDescription = NSEntityDescription.penaltyEntity() else {
            return
        }
        
        let predicate = NSPredicate(format: "penaltyId = %@", penalty.id)
        deleteItem(entityDescription, predicate: predicate) { (success) in
            
        }
    }
    
    // MARK: - Private

    private func saveWith(entityDescription entityDescription: NSEntityDescription, id: String, completion:(managedPenalty: ManagedPenalty?)->()) {
        
        let predicate = NSPredicate(format: "penaltyId = %@", id)
        
        saveItem(entityDescription, predicate: predicate) { (object) in
            guard let managedPenalty = object as? ManagedPenalty else {
                
                let newPenalty = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedPenalty
                
                completion(managedPenalty: newPenalty)
                return
            }
            completion(managedPenalty: managedPenalty)
        }
    }
}