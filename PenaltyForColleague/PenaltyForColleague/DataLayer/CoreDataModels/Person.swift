//
//  Person.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var photoName: String?
    @NSManaged var email: String?
    @NSManaged var surname: String?
    @NSManaged var name: String?
}
