//
//  AddTeamMemberVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreData

class AddTeamMemberVC: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectPhoto(sender: UIButton) {
        
    }
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        guard let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) else {
            return
        }
        
        let newTeamMember = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as? Person
        newTeamMember?.name = nameTextfield.text
        newTeamMember?.surname = surnameTextfield.text
        newTeamMember?.email = emailTextfield.text
        newTeamMember?.photoName = String(photoImageView.image)
        
        print(newTeamMember)
        
        // Save object in reserve storage
        do {
            try newTeamMember?.managedObjectContext?.save()
        } catch {
            print(error)
            let alert = UIAlertController(title: "Error", message: "Data weren't saved.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}