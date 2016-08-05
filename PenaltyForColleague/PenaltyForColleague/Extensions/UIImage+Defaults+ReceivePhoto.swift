//
//  UIImage+Defaults.swift
//  PenaltyForColleague
//
//  Created by IOS developer on 7/23/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: - Default icons
    
    class func defaultPersonIcon() -> UIImage? {
        return UIImage(named: "nobody")
    }
    
    // MARK: - Receive photo
    
    class func receivePhoto(photoName: String) -> UIImage? {
        guard let data = FileSystem().getFile(photoName) else {
            return nil
        }
        
        return UIImage(data: data)
    }
}