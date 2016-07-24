//
//  GCD.swift
//  PenaltyForColleague
//
//  Created by IOS developer on 7/23/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation

func dispatch_main(block: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func dispatch_main_after(seconds: Int, block: dispatch_block_t) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds) * Int64(NSEC_PER_SEC))
    dispatch_after(when, dispatch_get_main_queue(), block)
}
