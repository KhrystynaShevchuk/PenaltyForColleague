//
//  Person+Convert.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension Person {
    
    class func updatePersonWith(managedPerson managedPerson: ManagedPerson) -> Person {
        let person = Person()
    
        person.id = managedPerson.personId ?? ""
        person.name = managedPerson.name
        person.surname = managedPerson.surname
        person.email = managedPerson.email
        person.photoName = managedPerson.photoName
        if let photoName = person.photoName {
            person.photo = TeamAndPersonDBManager.sharedInstance.receivePhoto(photoName)
        }
        return person
    }
}