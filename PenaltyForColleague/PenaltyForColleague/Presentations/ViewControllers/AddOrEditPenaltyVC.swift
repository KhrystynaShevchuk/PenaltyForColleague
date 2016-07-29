//
//  AddOrEditPenaltyVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/25/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class AddOrEditPenaltyVC: UIViewController {
    
    @IBOutlet weak var fillInPenaltyLabel: UILabel!
    @IBOutlet weak var penaltyTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    let penaltyDBManager = PenaltyDBManager()
    
    var existPenalty: Penalty?
    var penaltyToSave = Penalty()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillPenaltyData()
    }
    
    // MARK: - Actions
    
    @IBAction func tappedSaveButton(sender: UIBarButtonItem) {
        savePenaltyData()
    }
    
    @IBAction func tappedDeleteButton(sender: UIButton) {
        deletePenalty()
    }
    
    // MARK: - Private
    
    private func prefillPenaltyData() {
        if existPenalty == nil {
            isDeleteButtonVisible(false)
            return
        }
        
        isDeleteButtonVisible(true)
        penaltyToSave.updatePenaltyWithPenalty(existPenalty)
        penaltyTextView.text = penaltyToSave.penaltyDescription
    }
    
    private func fillInPenaltyData() {
        penaltyToSave.penaltyDescription = penaltyTextView.text
    }
    
    private func savePenaltyData() {
        fillInPenaltyData()

        if penaltyToSave.penaltyDescription?.characters.count == 0 {
            presentAlertWithTitle("You can't save changes", message: "Fill in the 'Penalty description' field")
            return
        }
        
        penaltyDBManager.savePenalty(penaltyToSave) { (success) in
            if success {
                self.navigateBack()
            } else {
                self.presentAlertWithTitle("Error", message: "Data weren't saved.")
            }
        }
    }
    
    private func deletePenalty() {
        penaltyDBManager.deletePenalty(penaltyToSave)
        navigateBack()
    }
    
    private func isDeleteButtonVisible(visible: Bool) {
        if visible {
            deleteButton.hidden = false
        } else {
            deleteButton.hidden = true
        }
    }
    
    // MARK: - Navigation
    
    private func navigateBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}