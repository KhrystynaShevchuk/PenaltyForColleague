//
//  AddPersonVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/18/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class AddOrEditPersonVC: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var existPerson: Person?
    var personToSave = Person()
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillPersonData()
        
        imagePicker.delegate = self
        setUpTapGestureOnImageView()
    }
    
    // Mark: - Private
    
    private func prefillPersonData() {
        photoImageView.image = personToSave.photo ?? UIImage.defaultPersonIcon()
        if existPerson == nil {
            isDeleteButtonVisible(false)
            return
        }
        isDeleteButtonVisible(true)
        
        personToSave.updatePersonWithPerson(existPerson)
        
        nameTextfield.text = personToSave.name
        surnameTextfield.text = personToSave.surname
        emailTextfield.text = personToSave.email
    }
   
    private func fillInPersonData(){
        personToSave.name = nameTextfield.text
        personToSave.surname = surnameTextfield.text
        personToSave.email = emailTextfield.text
        personToSave.photo = photoImageView.image
    }
    
    private func savePersonData() {
        fillInPersonData()
        
        if personToSave.name?.characters.count == 0 {
            presentAlertWithTitle("You can't save changes", message: "Fill in the 'name' field")
            return
        }
        
        TeamAndPersonDBManager.sharedInstance.savePerson(personToSave) { (success) in
            if success {
                self.navigateBack()
            }
            else {
                self.presentAlertWithTitle("Error", message: "Data weren't saved.")
            }
        }
    }
    
    private func deletePersonData() {
        TeamAndPersonDBManager.sharedInstance.deletePerson(personToSave)
        navigateBack()
    }
    
    
    private func updatePersonImage(image: UIImage) {
        personToSave.photoName = NSUUID().UUIDString
        personToSave.photo = image
    }
    
    private func isDeleteButtonVisible(visible: Bool) {
        if visible {
            deleteButton.hidden = false
        } else {
            deleteButton.hidden = true
        }
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
    
    @IBAction func tappedDeleteButton(sender: UIButton) {
        deletePersonData()
    }
    
    //MARK: - Navigation
    
    private func navigateBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - Image picker

extension AddOrEditPersonVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .ScaleAspectFit
            photoImageView.image = pickedImage
            personToSave.photo = pickedImage
            
            updatePersonImage(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}