//
//  TeamMembers.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class TeamMember {
    
    var name = String()
    var surname: String?
    var email: String?
    var photo: String?
    
    init(name: String, surname: String, email: String, photo: String){
        self.name = name
        self.surname = surname
        self.email = email
        self.photo = photo
    }
}