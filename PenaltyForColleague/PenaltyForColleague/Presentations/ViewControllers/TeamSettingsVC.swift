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
    var team = Team()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        team = TeamAndPersonDBManager.sharedInstance.getCurrentTeam(team)
        prefillTeamData()

        imagePicker.delegate = self
        setUpTapGestureOnImageView()
    }
    
    // MARK: - Private 
    
    private func prefillTeamData() {
        logoImageView.image = team.photo ?? UIImage(named: "teamIcon")
        nameTextField.text = team.name
    }
    
    private func fillInTeamData(team: Team) {
        team.name = nameTextField.text
        team.photo = logoImageView.image
    }
    
    private func saveTeamData() {
        fillInTeamData(team)
        
        if nameTextField.text == "" {
            presentAlertWithTitle("You can't save changes", message: "Fill in the 'name' field")
            return
        }
        
        TeamAndPersonDBManager.sharedInstance.saveTeam(team) { (success) in
            if success {
                self.navigateBack()
            }
            else {
                self.presentAlertWithTitle("Error", message: "Data weren't saved.")
            }
        }
    }
    
    private func updateTeamImage(image: UIImage) {
        team.photoName = NSUUID().UUIDString
        team.photo = image
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
            team.photo = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}