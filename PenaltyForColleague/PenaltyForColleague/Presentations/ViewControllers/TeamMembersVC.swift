//
//  UsersVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class TeamMembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var members = [TeamMember]()
    let fileManager = NSFileManager()
    let dbManager = UserDBManager()
    
    var selectedPerson: TeamMember?
    
    // MARK: - vc life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        dbManager.getAllTeamMembers { (users) in
            if let users = users {
                self.members = users
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addUserButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMemberSegue", sender: nil)
    }
    
    // MARK: - prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editMemberSegue" {
            let vc = segue.destinationViewController as! AddTeamMemberVC
            if let selectedPerson = selectedPerson {
                vc.teamMember = selectedPerson
            }
        }
    }
}

// MARK: - extension

extension TeamMembersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamMembersCell") as! TeamMembersCell

        let member = members[indexPath.row]
        cell.iconImageView.image = UIImage(named: "userIcon")
        
        if (member.photo != nil) {
            cell.iconImageView.image = member.photo
        }
        
        cell.memberNameLabel.text = "\(member.name ?? "") \(member.surname ?? "")"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPerson = members[indexPath.row]
        
        performSegueWithIdentifier("editMemberSegue", sender: nil)
    }
}