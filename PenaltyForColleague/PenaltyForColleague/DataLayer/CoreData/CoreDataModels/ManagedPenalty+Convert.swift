//
//  ManagedPenalty+Convert.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension ManagedPenalty {
    
    func updateManagedPenalty(managedPenalty: ManagedPenalty, withPenalty penalty: Penalty) -> ManagedPenalty{
        managedPenalty.penaltyId = penalty.id
        managedPenalty.penalty = penalty.penaltyDescription

        return managedPenalty
    }
}