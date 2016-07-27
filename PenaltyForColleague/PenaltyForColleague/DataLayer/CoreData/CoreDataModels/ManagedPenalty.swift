//
//  Penalty.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/25/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation
import CoreData

class ManagedPenalty: NSManagedObject {

    @NSManaged var penaltyId: String?
    @NSManaged var penalty: String?
}