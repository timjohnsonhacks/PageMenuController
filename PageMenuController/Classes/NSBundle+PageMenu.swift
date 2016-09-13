//
//  NSBundle+PageMenu.swift
//  Pods
//
//  Created by Tim Johnson on 9/12/16.
//
//

import Foundation

private struct Constants {
    
    static let ResourceBundlePath = "PageMenuController.bundle"
}

extension NSBundle {
    
    class func pmc_pageMenuResourceBundle() -> NSBundle? {
        
        let pageMenuControllerBundle = NSBundle(forClass: PageMenuController.classForCoder())
        
        if let resourceURL = pageMenuControllerBundle.resourceURL?.URLByAppendingPathComponent(Constants.ResourceBundlePath) {
         
            return NSBundle(URL: resourceURL)
        }
        
        return nil
    }
}