//
//  PenaltiesVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/25/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

private let segueToAddPenalty = "addPenaltySegue"
private let segueToEditPenalty = "editPenaltySegue"

class PenaltiesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let penaltyDBManager = PenaltyDBManager()
    
    var penalties = [Penalty]()
    var selectedPenalty: Penalty?
    var constantPenalty = Penalty()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        receiveData()
    }
    
    // MARK: - Private
    
    private func receiveData() {
        
        penaltyDBManager.getAllPenalties { (penalties) in
            if penalties.isEmpty {
                self.constantPenalty.penaltyDescription = "nothing to do."
                self.penaltyDBManager.savePenalty(self.constantPenalty, completion: { (success) in
                    self.penalties.append(self.constantPenalty)
                })
                
            } else {
                self.penalties = penalties
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tappedAddButton(sender: UIBarButtonItem) {
        navigateToAddPenalty(sender)
    }
    
    // MARK: - Navigation 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToEditPenalty {
            let vc = segue.destinationViewController as! AddOrEditPenaltyVC
            if let selectedPenalty = selectedPenalty {
                vc.existPenalty = selectedPenalty
            }
        }
    }
    
    private func navigateToAddPenalty(sender: UIBarButtonItem) {
            performSegueWithIdentifier(segueToAddPenalty, sender: sender)
    }

    private func navigateToEditPenalty() {
        if penalties.count > 0 {
            performSegueWithIdentifier(segueToEditPenalty, sender: nil)
        }
    }
}

// MARK: - Table view

extension PenaltiesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return penalties.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PenaltiesCell.cellIdentifier, forIndexPath: indexPath) as! PenaltiesCell
        
        if indexPath.row == 0 {
            cell.isEditable(false)
            cell.penaltyLabel.text = penalties[indexPath.row].penaltyDescription
            
        } else {
            cell.config(penalties[indexPath.row])
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            return
        } else {
            selectedPenalty = penalties[indexPath.row]
            
            navigateToEditPenalty()
        }
    }
}