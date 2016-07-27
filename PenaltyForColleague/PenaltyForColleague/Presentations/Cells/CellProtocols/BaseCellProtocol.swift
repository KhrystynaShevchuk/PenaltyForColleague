//
//  Cells.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

protocol BaseCellProtocol {
    
    func cleanCell()
    static var cellIdentifier: String { get }
}

extension BaseCellProtocol where Self : UITableViewCell {
    static var cellIdentifier: String {
        return String(self)
    }
}