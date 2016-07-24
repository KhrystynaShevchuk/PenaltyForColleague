//
//  UsersVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

private let segueToAddPerson = "addPersonSegue"
private let segueToEditPerson = "editPersonSegue"

class TeamMembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var members = [Person]()
    var selectedPerson: Person?
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        TeamMemberDBManager.sharedInstance.getAllPersons { (persons) in
            self.members = persons
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addPersonButton(sender: UIBarButtonItem) {
        navigateToAddPerson()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToEditPerson {
            let vc = segue.destinationViewController as! AddPersonVC
            if let selectedPerson = selectedPerson {
                vc.person = selectedPerson
            }
        }
    }
    
    private func navigateToAddPerson() {
        performSegueWithIdentifier(segueToAddPerson, sender: self)
    }
    
    private func navigateToEditPerson() {
        performSegueWithIdentifier(segueToEditPerson, sender: self)
    }
}

// MARK: - extension

extension TeamMembersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TeamMembersCell.cellIdentifier) as! TeamMembersCell
        
        let person = members[safe: indexPath.row] ?? Person() // without any crashes in more complicated actions with arrays
        
        cell.iconImageView.image = person.photo ?? UIImage.defaultPersonIcon()
        cell.memberNameLabel.text = "\(person.name ?? "") \(person.surname ?? "")"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPerson = members[indexPath.row]
        
        navigateToEditPerson()
    }
}