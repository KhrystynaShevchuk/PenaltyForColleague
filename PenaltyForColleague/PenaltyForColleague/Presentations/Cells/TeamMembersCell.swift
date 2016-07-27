//
//  TeamMembersCell.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/26/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class TeamMembersCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
}

extension TeamMembersCell {
    
    func config(person: Person?) {
        cleanCell()
        
        if let person = person {
            iconImageView.image = person.photo ?? UIImage.defaultPersonIcon()
            memberNameLabel.text = "\(person.name ?? "") \(person.surname ?? "")"
        }
    }
}

extension TeamMembersCell: BaseCellProtocol {

    func cleanCell() {
        iconImageView.image = UIImage.defaultPersonIcon()
        memberNameLabel.text = nil
    }
}