//
//  TeamSettingsVC.swift
//  PenaltyForColleague
//
//  Created by IOS developer on 7/22/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class TeamSettingsVC: UIViewController {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamLogoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var teamMembers = TeamMembers()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setUpTapGestureOnImageView()
        
        TeamMemberDBManager.sharedInstance.getTeamMembers { (teamMembers) in
            self.teamMembers = teamMembers
            
            self.logoImageView.image = teamMembers.photo
            self.nameTextField.text = teamMembers.name
        }
        
        prefillTeamData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    // MARK: - Private 
    
    private func prefillTeamData() {
        logoImageView.image = teamMembers.photo ?? UIImage(named: "teamIcon")
        nameTextField.text = teamMembers.name
    }
    
    private func fillInTeamData(teamMembers: TeamMembers) {
        teamMembers.name = nameTextField.text ?? ""
        teamMembers.photo = logoImageView.image
    }
    
    // MARK: - Tap gestures
    
    private func setUpTapGestureOnImageView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        logoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker)
    }
    
    // MARK: - Actions
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        saveTeamData()
    }
    
    private func saveTeamData() {
        if nameTextField.text != "" {
            fillInTeamData(teamMembers)
            
            TeamMemberDBManager.sharedInstance.saveTeam(teamMembers)
            
            navigateBack()
        } else {
            presentAlertWithTitle("You can't save changes", message: "Fill in the 'name' field")
        }
    }
    
    //MARK: - Navigation
    
    private func navigateBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - Image picker

extension TeamSettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            logoImageView.contentMode = .ScaleAspectFit
            logoImageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
