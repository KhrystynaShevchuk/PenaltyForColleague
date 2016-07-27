//
//  Team.swift
//  PenaltyForColleague
//
//  Created by IOS developer on 7/23/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class Team {
        
    var id: String = ""
    var name: String?
    var photoName: String? = NSUUID().UUIDString
    var photo: UIImage?
    
    init() {
        id = NSUUID().UUIDString
    }
    
    func updateTeamWithTeam(team: Team?) {
        guard let team = team else {
            return
        }
        
        id = team.id
        name = team.name
        photoName = team.photoName
        photo = team.photo
    }
}