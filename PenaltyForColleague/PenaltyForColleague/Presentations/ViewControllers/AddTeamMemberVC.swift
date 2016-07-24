//
//  AddPersonVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class AddPersonVC: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var person = Person()
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setUpTapGestureOnImageView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        prefillPersonData()
    }
    
    // Mark: - Private
    
    private func prefillPersonData() {
        photoImageView.image = UIImage.defaultPersonIcon()
        
        nameTextfield.text = person.name
        surnameTextfield.text = person.surname
        emailTextfield.text = person.email
        photoImageView.image = person.photo ?? UIImage.defaultPersonIcon()
    }
    
    private func fillInPersonData(person: Person){
        person.name = nameTextfield.text
        person.surname = surnameTextfield.text
        person.email = emailTextfield.text
        person.photo = photoImageView.image
    }
    
    // MARK: - Tap gestures
    
    private func setUpTapGestureOnImageView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        photoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker)
    }
    
    // MARK: - Actions
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        savePersonData()
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        deletePersonData()
    }
    
    private func savePersonData() {
        if nameTextfield.text != "" {
            fillInPersonData(person)
            
            do {
                try TeamMemberDBManager.sharedInstance.savePerson(person)
            } catch {
                presentAlertWithTitle("Error", message: "Data weren't saved.")
            }
            
            navigateBack()
        } else {
            presentAlertWithTitle("You can't save changes", message: "Fill in the 'name' field")
        }
    }
    
    private func deletePersonData() {
        if let _ = person.objectID {
            TeamMemberDBManager.sharedInstance.deletePerson(person)
            navigateBack()
        }
    }
    
    //MARK: - Navigation
    
    private func navigateBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - Image picker

extension AddPersonVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .ScaleAspectFit
            photoImageView.image = pickedImage
            
            person.photoName = NSUUID().UUIDString
            fillInPersonData(person)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}