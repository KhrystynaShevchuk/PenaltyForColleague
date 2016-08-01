//
//  Array+RandomItem.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 8/1/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}