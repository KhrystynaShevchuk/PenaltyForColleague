//
//  Penalty.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/25/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class Penalty {
    
    var id: String = ""
    var penaltyDescription: String?
    
    init() {
        id = NSUUID().UUIDString
    }
    
    func updatePenaltyWithPenalty(penalty: Penalty?) {
        guard let penalty = penalty else {
            return
        }
        
        id = penalty.id
        penaltyDescription = penalty.penaltyDescription
    }
}