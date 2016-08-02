//
//  PenaltiesCell.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/27/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class PenaltiesCell: UITableViewCell {
    
    @IBOutlet weak var penaltyLabel: UILabel!
}

extension PenaltiesCell {
    
    func config(penalty: Penalty?) {
        cleanCell()
        
        guard let penalty = penalty else {
            return
        }
        penaltyLabel.text = "\(penalty.penaltyDescription ?? "")"
    }
    
    func isEditable(editable: Bool) {
        if !editable {
            penaltyLabel.enabled = true
        } else {
            penaltyLabel.enabled = false
        }
    }
}

extension PenaltiesCell: BaseCellProtocol {
    
    func cleanCell() {
        penaltyLabel.text = nil
    }
}