//
//  ManagedPerson+Convert.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension ManagedPerson {
    
    func updateManagedPerson(managedPerson: ManagedPerson, withPerson person: Person) -> ManagedPerson {
        
        managedPerson.name = person.name
        managedPerson.surname = person.surname
        managedPerson.email = person.email
        managedPerson.photoName = person.photoName
        managedPerson.personId = person.id
        
        return managedPerson
    }
}