//
//  UsersVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

enum ModeVC {
    case Main
    case Settings
}

private let segueToAddPerson = "addPersonSegue"
private let segueToEditPerson = "editPersonSegue"

class TeamMembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPersonBarButton: UIBarButtonItem!
    
    let personDBManager = PersonDBManager()
    
    var delegate: GetPersonProtocol?
    var mode: ModeVC = .Main
    
    var members = [Person]()
    var selectedPerson: Person?
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .Main {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        receiveData()
    }
    
    // MARK: - Private
    
    private func receiveData() {
        personDBManager.getAllPersons { (persons) in
            self.members = persons
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addPersonButton(sender: UIBarButtonItem) {
        navigateToAddPerson(sender)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToEditPerson {
            let vc = segue.destinationViewController as! AddOrEditPersonVC
            if let selectedPerson = selectedPerson {
                vc.existPerson = selectedPerson
            }
        }
    }
    
    private func navigateToAddPerson(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueToAddPerson, sender: sender)
    }
    
    private func navigateToEditPerson() {
        performSegueWithIdentifier(segueToEditPerson, sender: self)
    }
}

// MARK: - Table view

extension TeamMembersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TeamMembersCell.cellIdentifier) as! TeamMembersCell
        
        cell.config(members[indexPath.row])
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPerson = members[indexPath.row]        
        
        if mode == .Main {
            if let person = selectedPerson {
                delegate?.getPerson(person)
            }
            navigationController?.popToRootViewControllerAnimated(true)
        } else {
            navigateToEditPerson()
        }
    }
}