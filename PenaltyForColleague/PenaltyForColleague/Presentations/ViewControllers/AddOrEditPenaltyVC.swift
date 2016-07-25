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
    
    var penalty = Penalty()
    
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
    
    private func fillInPenaltyData() {
        penalty.penaltyDescription = penaltyTextView.text
    }
    
    private func prefillPenaltyData() {
        penaltyTextView.text = penalty.penaltyDescription
    }
    
    private func savePenaltyData() {
        if penaltyTextView.text != "" {
            fillInPenaltyData()
            
            do {
                try PenaltyDBManager.sharedInstance.savePenalty(penalty)
            } catch {
                presentAlertWithTitle("Error", message: "Data weren't saved.")
            }
            
            navigateBack()
        } else {
            presentAlertWithTitle("Error", message: "Data weren't saved.")
        }
    }
    
    private func deletePenalty() {
        if penalty.objectID != nil {
            PenaltyDBManager.sharedInstance.deletePenalty(penalty)
            
            navigateBack()
        }
    }
    
    // MARK: - Navigation
    
    private func navigateBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}
