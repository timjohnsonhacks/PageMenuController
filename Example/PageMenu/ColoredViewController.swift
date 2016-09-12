//
//  ColoredViewController.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

class ColoredViewController: UIViewController {
    
    var color: UIColor? {
        
        didSet {
            
            self.view.backgroundColor = color
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("VIEW WILL APPEAR")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("VIEW DID APPEAR")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("VIEW WILL DISAPPEAR")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("VIEW DID DISAPPEAR")
    }
}