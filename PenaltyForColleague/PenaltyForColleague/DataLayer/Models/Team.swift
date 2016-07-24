//
//  Team.swift
//  PenaltyForColleague
//
//  Created by IOS developer on 7/23/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class Team {
    
    var objectID: NSManagedObjectID?
    
    var name: String?
    var photoName: String? = NSUUID().UUIDString
    var photo: UIImage?
}
