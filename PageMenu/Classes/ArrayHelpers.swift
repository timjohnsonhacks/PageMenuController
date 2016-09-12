//
//  ArrayHelpers.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
