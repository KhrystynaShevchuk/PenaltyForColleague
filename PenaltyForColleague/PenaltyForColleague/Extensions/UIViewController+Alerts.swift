//
//  UIViewController+Alerts.swift
//  PenaltyForColleague
//
//  Created by IOS developer on 7/23/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentViewController(vc: UIViewController) {
        presentViewController(vc, animated: true, completion: nil)
    }
}

extension UINavigationController {
    
    func pushViewController(vc: UIViewController) {
        pushViewController(vc, animated: true)
    }
}