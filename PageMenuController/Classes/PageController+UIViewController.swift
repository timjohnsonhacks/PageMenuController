//
//  PageController+UIViewController.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func pmc_addChildViewController(_ viewController: UIViewController, inView view: UIView) {
        
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    func pmc_removeChildViewControllerFromView(_ viewController: UIViewController) {
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
