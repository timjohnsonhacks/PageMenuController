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
        
        let pageMenu = PageMenu()
        
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
        
        pageMenu.viewControllers = [blueViewController, redViewController, orangeViewController, purpleViewController]
        
        self.addChildViewController(pageMenu)
        self.view.addSubview(pageMenu.view)
        pageMenu.didMoveToParentViewController(self)
        
        pageMenu.view.snp_makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
        }
    }

}

