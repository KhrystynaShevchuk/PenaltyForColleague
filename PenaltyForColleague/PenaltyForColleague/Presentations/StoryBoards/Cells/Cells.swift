//
//  Cells.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

// MARK: - CellIdentifier protocol

protocol CellIdentifier {
    static var cellIdentifier: String { get }
}

extension CellIdentifier where Self : UITableViewCell {
    static var cellIdentifier: String {
        return String(self)
    }
}

// MARK: - Cells

class SettingsCell: UITableViewCell, CellIdentifier {
    
    @IBOutlet weak var settingLabel: UILabel!
}

class TeamMembersCell: UITableViewCell, CellIdentifier {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
}