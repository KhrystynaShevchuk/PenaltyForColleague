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
    
    func savePenalty(penalty: Penalty, completion: (success: Bool) -> ()) {
        guard let entityDescription = NSEntityDescription.penaltyEntity() else {
            completion(success: false)
            return
        }
        
        getManagedPenalty(entityDescription, id: penalty.id) { (managedPenalty) in
            let saveManagedPenalty = managedPenalty.updateManagedPenalty(managedPenalty, withPenalty: penalty)
            self.savePenaltyObjectInStorage(saveManagedPenalty)
            
            completion(success: true)
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
                var penalty = Penalty()
                penalty = Penalty.updatePenaltyWith(managedPenalty: managedPenalty)
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
        if penalty.id.isEmpty {
            return
        }
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.penaltyEntity()
        fetchRequest.entity = entityDescription
        var managedPenalties = [ManagedPenalty]()
        do {
            managedPenalties = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedPenalty]
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        
        for mPenalty in managedPenalties {
            if penalty.id == mPenalty.penaltyId {
                deletePenaltyObjectFromStorage(mPenalty)
            }
        }
    }
    
    // MARK: - Private
    
    private func getManagedPenalty(entityDescription: NSEntityDescription, id: String, completion: (managedPenalty: ManagedPenalty) -> ()) {
        getPenaltyForSave(id) { (managedPenalty) in
            if let penalty = managedPenalty {
                completion(managedPenalty: penalty)
            } else {
                let newPenalty = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! ManagedPenalty
                
                completion(managedPenalty: newPenalty)
            }
        }
    }
    
    private func getPenaltyForSave(id: String, completion: (managedPenalty: ManagedPenalty?) -> ()) {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.penaltyEntity()
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "penaltyId = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            let managedPenalties = result as! [ManagedPenalty]
            
            guard let mPenalty = managedPenalties.first else {
                completion(managedPenalty: nil)
                return
            }
            
            completion(managedPenalty: mPenalty)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            completion(managedPenalty: nil)
        }
    }
        
    private func deletePenaltyObjectFromStorage(managedPenalty: ManagedPenalty) {
        CoreDataStack.sharedInstance.managedObjectContext.deleteObject(managedPenalty)
        do {
            try CoreDataStack.sharedInstance.managedObjectContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    private func savePenaltyObjectInStorage(managedPenalty: ManagedPenalty) {
        
        do {
            try managedPenalty.managedObjectContext?.save()
        } catch {
            let savedError = error as NSError
            print(savedError)
        }
    }
}