//
//  Team+Convert.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension Team {
    
    func updateTeamWith(managedTeam managedTeam: ManagedTeam) -> Team {
        let team = Team()
        
        team.id = managedTeam.teamId ?? ""
        team.name = managedTeam.name
        team.photoName = managedTeam.photoName
        if let photoName = managedTeam.photoName {
            team.photo = UIImage.receivePhoto(photoName)
        }
        
        return team
    }
}