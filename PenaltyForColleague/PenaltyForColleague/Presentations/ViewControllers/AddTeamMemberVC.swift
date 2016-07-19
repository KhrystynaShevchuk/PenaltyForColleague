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
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setTapGestureOnImageView()
    }
    
    private func setTapGestureOnImageView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        guard let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) else {
            return
        }
        if nameTextfield.text != "" {
            
            let newTeamMember = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as? Person
            newTeamMember?.name = nameTextfield.text
            newTeamMember?.surname = surnameTextfield.text
            newTeamMember?.email = emailTextfield.text
            
            if photoImageView.image != nil {
                let photoName = NSUUID().UUIDString

                let imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.5)
                FileSystem().saveFile(photoName, data: imageData!)
                newTeamMember?.photoName = photoName
            }
            
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
            navigationController?.popViewControllerAnimated(true)
        } else {
            let alert = UIAlertController(title: "You can't save changes", message: "Fill in the 'name' field", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}

extension AddTeamMemberVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .ScaleAspectFit
            photoImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}