//
//  UIView+NibLoading.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    class func pmc_viewFromNib(_ nibNameOrNil: String? = nil) -> Self? {
        
        return self.pmc_viewFromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    class func pmc_viewFromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        
        var view: T?
        let name: String
        
        if let nibName = nibNameOrNil {
            
            name = nibName
        } else {
            
            name = self.pmc_nibName
        }
        
        if let nibViews = Bundle.pmc_pageMenuResourceBundle()?.loadNibNamed(name, owner: nil, options: nil) {
         
            for nibView in nibViews {
                
                if let nibView = nibView as? T {
                    
                    view = nibView
                }
            }
        }
        
        return view
    }
    
    class var pmc_nibName: String {
        
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    
    class var pmc_nib: UINib? {
        
        if let _ = Bundle.pmc_pageMenuResourceBundle()?.path(forResource: self.pmc_nibName, ofType: "nib") {
            
            return UINib(nibName: self.pmc_nibName, bundle: Bundle.pmc_pageMenuResourceBundle())
        } else {
            
            return nil
        }
    }
}
