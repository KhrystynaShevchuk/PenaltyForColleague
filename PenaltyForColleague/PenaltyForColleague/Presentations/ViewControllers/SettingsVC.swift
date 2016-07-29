//
//  SettingsVC.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/15/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

enum SettingType {
    case TeamMembers
    case TeamSettings
    case Penalties
    
    func title() -> String {
        switch self {
        case .TeamMembers:
            return "Team members"
        case .TeamSettings:
            return "Team settings"
        case .Penalties:
            return "Penalties"
        }
    }
}

private let segueToMembersVC = "usersSegue"
private let segueToTeamSettingsVC = "teamSettingsSegue"
private let segueToPenaltiesVC = "penaltiesSegue"

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingType: SettingType!
    var items: [SettingType] = [.TeamMembers, .TeamSettings, .Penalties]
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToMembersVC {
            if let vc = segue.destinationViewController as? TeamMembersVC {
                vc.vc = self
            }
        }
    }
 
    private func navigateToMembersVC() {
        performSegueWithIdentifier(segueToMembersVC, sender: nil)
    }
    
    private func navigateToTeamSettingsVC() {
        performSegueWithIdentifier(segueToTeamSettingsVC, sender: nil)
    }
    
    private func navigateToPenaltiesVC() {
        performSegueWithIdentifier(segueToPenaltiesVC, sender: nil)
    }
}

// MARK: - Table view

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SettingsCell.cellIdentifier) as! SettingsCell
        
        settingType = items[indexPath.row]
        
        cell.settingLabel.text = settingType.title()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = items[indexPath.row]
        
        switch item {
        case .TeamMembers:
            navigateToMembersVC()
        case .TeamSettings:
            navigateToTeamSettingsVC()
        case .Penalties:
            navigateToPenaltiesVC()
        }
    }
}