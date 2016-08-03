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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var processMessageLabel: UILabel!
    
    var person = Person()
    var penalty = Penalty()
    
    // MARK: - VC lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillWithData()
        complexActivityIndicator()
    }
    
    // MARK: - Private

    private func prefillWithData() {
        nameLabel.text = "\(person.name ?? "") \(person.surname ?? "")"
        penaltyTextView.hidden = true
        penaltyTextView.text = penalty.penaltyDescription
        
        penaltyWasPicked()
    }
    
    private func penaltyWasPicked() {
        dispatch_main_after(2) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.processMessageLabel.removeFromSuperview()
            self.penaltyTextView.hidden = false
        }
    }
    
    private func complexActivityIndicator() {
        processMessageLabel.hidden = false
        processMessageLabel.text = "Penalty is picking"
        processMessageLabel.textColor = UIColor.blackColor()
        
        setActivityIndicator()
    }

    private func setActivityIndicator() {
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.startAnimating()
    }
}