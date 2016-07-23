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
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setUpTapGestureOnImageView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        prefillTeamMemberData()
    }
    
    // Mark: - Private
    
    private func prefillTeamMemberData() {
        photoImageView.image = UIImage.defaultTeamMemberIcon()
        
        nameTextfield.text = teamMember.name
        surnameTextfield.text = teamMember.surname
        emailTextfield.text = teamMember.email
        photoImageView.image = teamMember.photo ?? UIImage.defaultTeamMemberIcon()
    }
    
    private func fillInTeamMemberData(teamMember: TeamMember){
        teamMember.name = nameTextfield.text
        teamMember.surname = surnameTextfield.text
        teamMember.email = emailTextfield.text
        teamMember.photo = photoImageView.image
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
        saveTeamMemberData()
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        deleteTeamMemberData()
    }
    
    private func saveTeamMemberData() {
        if nameTextfield.text != "" {
            fillInTeamMemberData(teamMember)
            
            do {
                try TeamMemberDBManager.sharedInstance.saveTeamMember(teamMember)
            } catch {
                presentAlertWithTitle("Error", message: "Data weren't saved.")
            }
            
            navigateBack()
        } else {
            presentAlertWithTitle("You can't save changes", message: "Fill in the 'name' field")
        }
    }
    
    private func deleteTeamMemberData() {
        if let _ = teamMember.objectID {
            TeamMemberDBManager.sharedInstance.deleteTeamMember(teamMember)
            navigateBack()
        }
    }
    
    //MARK: - Navigation
    
    private func navigateBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - Image picker

extension AddTeamMemberVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .ScaleAspectFit
            photoImageView.image = pickedImage
            
            teamMember.photoName = NSUUID().UUIDString
            fillInTeamMemberData(teamMember)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}