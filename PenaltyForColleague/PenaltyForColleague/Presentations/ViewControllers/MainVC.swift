//
//  ViewController.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/14/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

private let segueToSettingsVC = "settingsSegue"

class MainVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pickChangeButton: UIButton!
    
    var person: Person?
    
    // MARK: - VC life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(true)
        
        prefillPersonData()
    }
    
    // MARK: - Private 
    
    private func prefillPersonData() {
        if let personToFill = person {
            imageView.image = personToFill.photo ?? UIImage.defaultPersonIcon()
            nameLabel.text = "\(personToFill.name ?? "") \(personToFill.surname ?? "")"
            pickChangeButton.setTitle("Change", forState: UIControlState.Normal)
        } else {
            imageView.image = UIImage.defaultPersonIcon()
            nameLabel.text = "Pick failer  :)"
            pickChangeButton.setTitle("Pick", forState: UIControlState.Normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tapSettingButton(sender: UIBarButtonItem) {
        navigateToSettings(sender)
    }
    
    @IBAction func tappedPickChangeButton(sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    
    private func navigateToSettings(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueToSettingsVC, sender: sender)
    }
}