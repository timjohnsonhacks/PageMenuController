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
    
    class func viewFromNib(nibNameOrNil: String? = nil) -> Self? {
        
        return self.viewFromNib(nibNameOrNil, type: self)
    }
    
    class func viewFromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        
        var view: T?
        let name: String
        
        if let nibName = nibNameOrNil {
            
            name = nibName
        } else {
            
            name = self.nibName
        }
        
        if let nibViews = NSBundle.pageMenuBundle()?.loadNibNamed(name, owner: nil, options: nil) {
         
            for nibView in nibViews {
                
                if let nibView = nibView as? T {
                    
                    view = nibView
                }
            }
        }
        
        return view
    }
    
    class var nibName: String {
        
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    
    class var nib: UINib? {
        
        if let _ = NSBundle.pageMenuBundle()?.pathForResource(self.nibName, ofType: "nib") {
            
            return UINib(nibName: self.nibName, bundle: NSBundle.pageMenuBundle())
        } else {
            
            return nil
        }
    }
}