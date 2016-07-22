//
//  AddTeamMemberVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class AddTeamMemberVC: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var teamMember = TeamMember()
    
    
    //MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setTapGestureOnImageView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        prefillUserData()
    }
    
    // Mark: - private
    
    private func prefillUserData() {
        photoImageView.image = UIImage(named: "userIcon")
        
        nameTextfield.text = teamMember.name
        surnameTextfield.text = teamMember.surname
        emailTextfield.text = teamMember.email
        photoImageView.image = teamMember.photo ?? UIImage(named: "userIcon")
    }
    
    private func fillInPersonData(teamMember: TeamMember){
        teamMember.name = nameTextfield.text
        teamMember.surname = surnameTextfield.text
        teamMember.email = emailTextfield.text
        teamMember.photo = photoImageView.image
    }
    
    // MARK: - tap gesture
    
    private func setTapGestureOnImageView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        
        if (nameTextfield.text != "") {
            fillInPersonData(teamMember)
            
            do {
                try UserDBManager.sharedInstance.savePersonData(teamMember)
            } catch {
                print(error)
                let alert = UIAlertController(title: "Error", message: "Data weren't saved.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                AddTeamMemberVC().presentViewController(alert, animated: true, completion: nil)
            }
            
            navigationController?.popViewControllerAnimated(true)
        } else {
            let alert = UIAlertController(title: "You can't save changes", message: "Fill in the 'name' field", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        if (teamMember.objectID != nil) {
            UserDBManager.sharedInstance.deletePerson(teamMember)
            navigationController?.popViewControllerAnimated(true)
        }
    }
}

// MARK: - extension

extension AddTeamMemberVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .ScaleAspectFit
            photoImageView.image = pickedImage
            
            teamMember.photoName = NSUUID().UUIDString
            fillInPersonData(teamMember)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}