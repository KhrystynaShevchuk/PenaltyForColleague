//
//  SettingsVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var penaltiesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTapGestures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - gestures setup
    
    private func setTapGestures() {
        setTapGestOnMembersLabel()
        setTapGestOnSettingsLabel()
        setTapGestOnPenaltiesLabel()
    }
    
    private func setTapGestOnMembersLabel() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(SettingsVC.tapToTeamMembers(_:)))
        membersLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setTapGestOnSettingsLabel() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(SettingsVC.tapToTeamSettings(_:)))
        settingsLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setTapGestOnPenaltiesLabel() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(SettingsVC.tapToPenalties(_:)))
        penaltiesLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - gestures' actions
    
    func tapToTeamMembers(gestureRecognizer: UILongPressGestureRecognizer) {
        print(" members vc")
        
        performSegueWithIdentifier("usersSegue", sender: nil)
    }
    
    func tapToTeamSettings(gestureRecognizer: UILongPressGestureRecognizer) {
        print(" team settings vc")
    }
    
    func tapToPenalties(gestureRecognizer: UILongPressGestureRecognizer) {
        print(" penalties vc")
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}