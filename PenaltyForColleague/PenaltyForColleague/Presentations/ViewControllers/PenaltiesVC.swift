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
    
    var penalties = [Penalty]()
    var selectedPenalty: Penalty?
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        PenaltyDBManager.sharedInstance.getAllPenalties { (penalties) in
            self.penalties = penalties
            
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
                vc.penalty = selectedPenalty
            }
        }
    }
    
    private func navigateToAddPenalty(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueToAddPenalty, sender: sender)
    }

    private func navigateToEditPenalty() {
        performSegueWithIdentifier(segueToEditPenalty, sender: nil)
    }
}

// MARK: - Table view

extension PenaltiesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return penalties.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PenaltiesCell.cellIdentifier) as! PenaltiesCell
        
        let penalty = penalties[indexPath.row] ?? Penalty()
        
        cell.penaltyLabel.text = penalty.penaltyDescription ?? ""
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPenalty = penalties[indexPath.row]
        
        navigateToEditPenalty()
    }
}