//
//  RandomPenaltyVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/29/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class RandomPenaltyVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shouldDoLabel: UILabel!
    @IBOutlet weak var penaltyLabel: UILabel!
    
    var person = Person()
    var penalty = Penalty()
    
    // MARK: - VC lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}