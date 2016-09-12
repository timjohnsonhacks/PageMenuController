//
//  ViewController.swift
//  PageMenu
//
//  Created by Tim Johnson on 09/12/2016.
//  Copyright (c) 2016 Tim Johnson. All rights reserved.
//

import UIKit
import PageMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPageController()
    }
    
    func addPageController() {
        
        let pageMenuController = PageMenuController()
        
        let blueViewController = ColoredViewController()
        blueViewController.title = "BLUE"
        blueViewController.color = UIColor.blueColor()
        
        let redViewController = ColoredViewController()
        redViewController.title = "RED"
        redViewController.color = UIColor.redColor()
        
        let orangeViewController = ColoredViewController()
        orangeViewController.title = "ORANGE"
        orangeViewController.color = UIColor.orangeColor()
        
        let purpleViewController = ColoredViewController()
        purpleViewController.title = "PURPLE"
        purpleViewController.color = UIColor.purpleColor()
        
        pageMenuController.viewControllers = [blueViewController, redViewController, orangeViewController, purpleViewController]
        
        self.addChildViewController(pageMenuController)
        self.view.addSubview(pageMenuController.view)
        pageMenuController.didMoveToParentViewController(self)
        
        pageMenuController.view.snp_makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
        }
    }

}

