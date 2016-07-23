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
    
    static let allTypes = [SettingType.TeamMembers, SettingType.TeamSettings, SettingType.Penalties]
}

private let segueToMembersVC = "usersSegue"
private let segueToTeamSettingsVC = "teamSettingsSegue"

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingType: SettingType!
    var items = [SettingType]()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = SettingType.allTypes
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    private func navigateToMembersVC() {
        performSegueWithIdentifier(segueToMembersVC, sender: nil)
    }
    
    private func navigateToTeamSettingsVC() {
        performSegueWithIdentifier(segueToTeamSettingsVC, sender: nil)
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
            print(" members vc")
            navigateToMembersVC()
        case .TeamSettings:
            print(" team settings vc")
            navigateToTeamSettingsVC()
        case .Penalties:
            print(" penalties vc")
        }
    }
}
