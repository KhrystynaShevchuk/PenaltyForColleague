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
    @IBOutlet weak var penaltyTextView: UITextView!
    
    var person = Person()
    var penalty = Penalty()
    
    // MARK: - VC lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillWithData()
    }
    
    private func prefillWithData() {
        nameLabel.text = "\(person.name ?? "") \(person.surname ?? "")"
        penaltyTextView.text = penalty.penaltyDescription
    }
}