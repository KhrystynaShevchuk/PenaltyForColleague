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

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var settingType: SettingType!
    
    var items = [SettingType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [SettingType.TeamMembers, SettingType.TeamSettings, SettingType.Penalties]
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsCell
        settingType = items[indexPath.row]
        
        cell.settingLabel.text = settingType.title()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if items[indexPath.row] == SettingType.TeamMembers {
            print(" members vc")
            performSegueWithIdentifier("usersSegue", sender: nil)
        }
        
        if items[indexPath.row] == .TeamSettings {
            print(" team settings vc")
        }
        
        if items[indexPath.row] == .Penalties {
            print(" penalties vc")
        }
    }
}
