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

extension Bundle {
    
    class func pmc_pageMenuResourceBundle() -> Bundle? {
        
        let pageMenuControllerBundle = Bundle(for: PageMenuController.classForCoder())
        
        if let resourceURL = pageMenuControllerBundle.resourceURL?.appendingPathComponent(Constants.ResourceBundlePath) {
         
            return Bundle(url: resourceURL)
        }
        
        return nil
    }
}
