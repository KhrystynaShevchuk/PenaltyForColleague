//
//  Person.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class Person {
        
    var id: String = ""
    var name: String?
    var surname: String?
    var email: String?
    var photoName: String?
    var photo: UIImage?
    
    init() {
        id = NSUUID().UUIDString
    }
    
    func updatePersonWithPerson(person: Person?) {
        guard let person = person else {
            return
        }
        
        id = person.id
        name = person.name
        surname = person.surname
        email = person.email
        photoName = person.photoName
        photo = person.photo
    }
}