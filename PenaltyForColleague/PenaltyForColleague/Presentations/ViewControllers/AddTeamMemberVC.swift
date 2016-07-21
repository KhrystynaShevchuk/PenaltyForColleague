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
    var editablePerson: TeamMember?
    let person = TeamMember()

    
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
    
    private func prefillUserData() {
        photoImageView.image = UIImage(named: "userIcon")
        
        guard let user = editablePerson else {
            return
        }
        
        nameTextfield.text = user.name
        surnameTextfield.text = user.surname
        emailTextfield.text = user.email
        photoImageView.image = user.photo ?? UIImage(named: "userIcon")
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
    
    private func fillInPersonData(person: TeamMember){
        person.name = nameTextfield.text
        person.surname = surnameTextfield.text
        person.email = emailTextfield.text
        person.photo = photoImageView.image
    }
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        
        if (nameTextfield.text != "") {
            fillInPersonData(person)
            UserDBManager().savePersonData(person)
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
            person.photo = pickedImage
            person.photoName = NSUUID().UUIDString
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}