//
//  UsersVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

private let segueToAddMember = "addMemberSegue"
private let segueToEditMember = "editMemberSegue"

class TeamMembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var members = [TeamMember]()    
    var selectedPerson: TeamMember?
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        UserDBManager.sharedInstance.getAllTeamMembers { (users) in
            self.members = users
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addUserButton(sender: UIBarButtonItem) {
        navigateToAddMember()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToEditMember {
            let vc = segue.destinationViewController as! AddTeamMemberVC
            if let selectedPerson = selectedPerson {
                vc.teamMember = selectedPerson
            }
        }
    }
    
    private func navigateToAddMember() {
        performSegueWithIdentifier(segueToAddMember, sender: self)
    }
    
    private func navigateToEditMember() {
        performSegueWithIdentifier(segueToEditMember, sender: self)
    }
}

// MARK: - extension

extension TeamMembersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TeamMembersCell.cellIdentifier) as! TeamMembersCell
        
        let member = members[safe: indexPath.row] ?? TeamMember() // without any crashes in more complicated actions with arrays
        
        cell.iconImageView.image = member.photo ?? UIImage.defaultTeamMemberIcon()
        cell.memberNameLabel.text = "\(member.name ?? "") \(member.surname ?? "")"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPerson = members[indexPath.row]
        
        navigateToEditMember()
    }
}