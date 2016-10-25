//
//  ViewController.swift
//  PageMenu
//
//  Created by Tim Johnson on 09/12/2016.
//  Copyright (c) 2016 Tim Johnson. All rights reserved.
//

import UIKit
import PageMenuController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPageController()
    }
    
    func addPageController() {
        
        let pageMenuController = PageMenuController()
        
        let blueViewController = ColoredViewController()
        blueViewController.title = "BLUE"
        blueViewController.color = UIColor.blue
        
        let redViewController = ColoredViewController()
        redViewController.title = "RED"
        redViewController.color = UIColor.red
        
        let orangeViewController = ColoredViewController()
        orangeViewController.title = "ORANGE"
        orangeViewController.color = UIColor.orange
        
        let purpleViewController = ColoredViewController()
        purpleViewController.title = "PURPLE"
        purpleViewController.color = UIColor.purple
        
        pageMenuController.viewControllers = [blueViewController, redViewController, orangeViewController, purpleViewController]
        
        self.addChildViewController(pageMenuController)
        self.view.addSubview(pageMenuController.view)
        pageMenuController.didMove(toParentViewController: self)
        
        pageMenuController.view.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
        }
    }

}

