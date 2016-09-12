//
//  PageController.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum PageType {
    
    case Vertical
    case Horizontal
}

protocol PageControllerDelegate: class {
    
    func pagingScrollViewDidScroll(scrollView: UIScrollView)
}

class PageController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    internal var appearingViewController: UIViewController?
    internal var disappearingViewController: UIViewController?
    
    weak var delegate: PageControllerDelegate?
    
    var selectedIndex: Int = 0
    var lastOffset: CGFloat = 0
    
    var viewControllers: [UIViewController]? {
        
        didSet {
            
            self.removeViewControllers()
            self.setupViewControllers()
        }
    }
    
    var pageType: PageType = .Horizontal {
        
        didSet {

            self.adjustForPageType()
        }
    }
    
    init() {
        super.init(nibName: "PageController", bundle: NSBundle.pageMenuBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adjustForPageType()
        self.setupViewControllers()
    }
    
    private func removeViewControllers() {
        
        guard let viewControllers = self.viewControllers else {
            
            return
        }
        
        viewControllers.forEach({ (viewController: UIViewController) in
            
            self.removeChildViewController(viewController)
        })
    }
    
    private func adjustForPageType() {
        
        self.contentViewWidthConstraint.active = (self.pageType == .Vertical)
        self.contentViewHeightConstraint.active = (self.pageType == .Horizontal)
    }
    
    private func setupViewControllers() {
        
        guard let viewControllers = self.viewControllers,
            contentView = self.contentView else {
            
            return
        }
        
        var previousController: UIViewController? = nil
        viewControllers.forEach({ (viewController: UIViewController) in
            
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(viewController, inView: contentView)
            
            viewController.view.snp_makeConstraints(closure: { (make) in
                
                if self.pageType == .Horizontal {
                    
                    make.top.equalTo(contentView)
                    make.bottom.equalTo(contentView)
                    
                    if let previousController = previousController {
                        
                        make.leading.equalTo(previousController.view.snp_trailing)
                    }
                    
                    if viewControllers.first == viewController {
                     
                        make.leading.equalTo(contentView)
                    }
                    
                    if viewControllers.last == viewController {
                     
                        make.trailing.equalTo(contentView)
                    }
                    
                } else if self.pageType == .Vertical {
                    
                    make.leading.equalTo(contentView)
                    make.trailing.equalTo(contentView)
                    
                    if let previousController = previousController {
                        
                        make.top.equalTo(previousController.view.snp_bottom)
                    }
                    
                    if viewControllers.first == viewController {
                        
                        make.top.equalTo(contentView)
                    }
                    
                    if viewControllers.last == viewController {
                        
                        make.bottom.equalTo(contentView)
                    }
                }
                
                make.width.equalTo(self.view)
                make.height.equalTo(self.view)
            })
            
            previousController = viewController
        })
    }
}