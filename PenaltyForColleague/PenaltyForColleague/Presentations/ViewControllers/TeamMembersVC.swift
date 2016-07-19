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
    
    var members = [Person]()
    let fileManager = NSFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getDataAboutMembers()
    }
    
    // Get data
    func getDataAboutMembers() {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
            members = result as! [Person]
            print(result)
            tableView.reloadData()
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    @IBAction func addUserButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMemberSegue", sender: nil)
    }
    
    func receivePhoto (person: Person? ) -> UIImage? {
        guard let person = person else {
            return nil
        }
        
        let name = person.photoName!
        if let data = FileSystem().getFile(name) {
            let image = UIImage(data: data)
            return image
            
        } else {
            return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}

extension TeamMembersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamMembersCell") as! TeamMembersCell

        let person = members[indexPath.row]
        cell.iconImageView.image = UIImage(named: "userIcon")
        
        if let image = receivePhoto(person) {
            cell.iconImageView.image = image
        }
        
        cell.memberNameLabel.text = "\(person.name ?? "") \(person.surname ?? "")"
        return cell
    }
}