//
//  Penalty+Convert.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension Penalty {
    
    class func updatePenaltyWith(managedPenalty managedPenalty: ManagedPenalty) -> Penalty {
        let penalty = Penalty()
        
        penalty.id = managedPenalty.penaltyId ?? ""
        penalty.penaltyDescription = managedPenalty.penalty
        
        return penalty
    }
}