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
    
    // MARK: - VC life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func tapSettingButton(sender: UIBarButtonItem) {
        navigateToSettings(sender)
    }
    
    // MARK: - Navigation
    
    private func navigateToSettings(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueToSettingsVC, sender: sender)
    }
}