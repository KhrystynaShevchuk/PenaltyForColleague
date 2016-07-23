//
//  FileSystem.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 7/19/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation

class FileSystem {
    
    func getFile(name: String) -> NSData? {
        return NSFileManager.defaultManager().contentsAtPath(pathString(name))
    }
    
    func saveFile(name: String, data: NSData) {
        NSFileManager.defaultManager().createFileAtPath(pathString(name), contents: data, attributes: nil)
    }
    
    func pathString(name: String) -> String {
        let path = NSFileManager.documentsDir() + "/\(name)"
        print(path)
        
        return path
    }
}