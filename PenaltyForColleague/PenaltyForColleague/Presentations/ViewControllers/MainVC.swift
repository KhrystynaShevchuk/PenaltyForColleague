//
//  ViewController.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/14/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapSettingButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("settingsSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

