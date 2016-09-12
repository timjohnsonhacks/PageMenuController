//
//  NSBundle+PageMenu.swift
//  Pods
//
//  Created by Tim Johnson on 9/12/16.
//
//

import Foundation

extension NSBundle {
    
    class func pmc_pageMenuBundle() -> NSBundle? {
        
        return NSBundle(forClass: PageMenuController.classForCoder())
    }
}