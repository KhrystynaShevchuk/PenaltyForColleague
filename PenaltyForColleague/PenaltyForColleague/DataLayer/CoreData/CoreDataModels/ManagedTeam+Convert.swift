//
//  ManagedTeam+Convert.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension ManagedTeam {
    
    func updateManagedTeam(managedTeam: ManagedTeam, withTeam team: Team) -> ManagedTeam {
        managedTeam.teamId = team.id
        managedTeam.name = team.name
        managedTeam.photoName = team.photoName
        
        return managedTeam
    }
}