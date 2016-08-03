
//
//  GCDExtension.swift
//  PenaltyForColleague
//
//  Created by KhrystynaShevchuk on 8/3/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation

func dispatch_main_after(seconds: Int, block: dispatch_block_t) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds) * Int64(NSEC_PER_SEC))
    dispatch_after(when, dispatch_get_main_queue(), block)
}