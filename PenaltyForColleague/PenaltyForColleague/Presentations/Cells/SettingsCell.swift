//
//  SettingsCell.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/27/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
}

extension SettingsCell: BaseCellProtocol {
    
    func cleanCell() {
        settingLabel.text = nil
    }
}