//
//  NSBundle+PageMenu.swift
//  Pods
//
//  Created by Tim Johnson on 9/12/16.
//
//

import Foundation

extension NSBundle {
    
    class func pageMenuBundle() -> NSBundle? {
        
        return NSBundle(forClass: PageMenu.classForCoder())
    }
}