//
//  ViewController.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/14/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

private let segueToSettingsVC = "settingsSegue"
private let segueToTeamMembersVC = "pickPersonSegue"
private let segueToRandomPenaltyVC = "generatePenaltyForFailerSegue"

class MainVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pickPersonButton: UIButton!
    @IBOutlet weak var getPenaltyButton: UIButton!
    
    let personDBManager = PersonDBManager()
    let penaltyDBmanager = PenaltyDBManager()
    
    var persons: [Person]?
    var penalties: [Penalty]?
    var person: Person?
    var randomPenalty = Penalty()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        getPersons()
        getPenalties()
        prefillPersonData()
    }
    
    // MARK: - Private
    
    private func prefillPersonData() {
        
        imageView.image = UIImage.defaultPersonIcon()
        
        if persons?.count == 0 {
            pickPersonButton.hidden = true
            nameLabel.hidden = false
            nameLabel.text = "Add people in settings. "
            getPenaltyButton.hidden = true
            
        } else {
            nameLabel.hidden = true
            pickPersonButton.hidden = false
            dataToPrefill()
        }
    }
    
    private func dataToPrefill() {
        guard let pickedPerson = person else {
            getPenaltyButton.hidden = true
            pickPersonButton.setTitle("Pick failer  :)", forState: UIControlState.Normal)
            return
        }
        
        imageView.image = pickedPerson.photo ?? UIImage.defaultPersonIcon()
        pickPersonButton.setTitle("\(pickedPerson.name ?? "") \(pickedPerson.surname ?? "")", forState: UIControlState.Normal)
        getPenaltyButton.hidden = false
    }
    
    private func getPersons() {
        personDBManager.getAllPersons { (persons) in
            self.persons = persons
        }
    }
    
    private func getPenalties() {
        penaltyDBmanager.getAllPenalties { (penalties) in
            self.penalties = penalties
        }
    }
    
    private func getRandomPenalty(sender: UIButton) {
        if penalties?.count > 0 {
            guard let existPenalties = penalties else {
                return
            }
            
            randomPenalty = existPenalties.randomItem()
            navigateToRandomPenalty(sender)
            
        } else {
            presentAlertWithTitle("There are no penalties.", message: "Add penalties in settings.")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tapSettingButton(sender: UIBarButtonItem) {
        navigateToSettings(sender)
    }
    
    @IBAction func tappedPickPersonButton(sender: UIButton) {
        navigateToTeamMembers(sender)
    }
    
    @IBAction func tappedGetPenaltyButton(sender: UIButton) {
        getRandomPenalty(sender)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToTeamMembersVC {
            if let vc = segue.destinationViewController as? TeamMembersVC {
                vc.delegate = self
                vc.mode = ModeVC.Main
            }
        }
        
        if segue.identifier == segueToRandomPenaltyVC {
            if let vc = segue.destinationViewController as? RandomPenaltyVC, let person = person {
                vc.person = person
                vc.penalty = randomPenalty
            }
        }
    }
    
    private func navigateToSettings(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueToSettingsVC, sender: sender)
    }
    
    private func navigateToTeamMembers(sender: UIButton) {
        performSegueWithIdentifier(segueToTeamMembersVC, sender: sender)
    }
    
    private func navigateToRandomPenalty(sender: UIButton) {
        performSegueWithIdentifier(segueToRandomPenaltyVC, sender: sender)
    }
}

extension MainVC: GetPersonProtocol {
    
    func getPerson(person: Person) {
        self.person = person
    }
}