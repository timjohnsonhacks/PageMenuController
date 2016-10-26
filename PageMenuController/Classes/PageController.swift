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
    
    case vertical
    case horizontal
}

protocol PageControllerDelegate: class {
    
    func pagingScrollViewDidScroll(_ scrollView: UIScrollView)
    func pagingScrollViewDidSelectViewController(_ controller: UIViewController, atIndex index: Int)
}

class PageController: UIViewController {
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var contentView: UIView!
    
    @IBOutlet fileprivate weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    internal var appearingViewController: UIViewController?
    internal var disappearingViewController: UIViewController?
    
    weak var delegate: PageControllerDelegate?
    
    var selectedIndex: Int = 0
    var lastOffset: CGFloat = 0
    
    var initialIndex: Int? {
        
        didSet {
            
            self.view.setNeedsLayout()
        }
    }
    
    var bounces: Bool = true {
        
        didSet {
            
            if self.scrollView != nil {
                
                self.scrollView.bounces = bounces
            }
        }
    }
    
    var backgroundColor: UIColor = UIColor.white {
        
        didSet {
            
            if self.scrollView != nil {
             
                self.scrollView.backgroundColor = backgroundColor
            }
        }
    }
    
    var viewControllers: [UIViewController]? {
        
        didSet {
            
            self.removeViewControllers()
            self.setupViewControllers()
        }
    }
    
    var pageType: PageType = .horizontal {
        
        didSet {

            self.adjustForPageType()
        }
    }
    
    init() {
        super.init(nibName: "PageController", bundle: Bundle.pmc_pageMenuResourceBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.scrollView.backgroundColor = self.backgroundColor
        self.scrollView.scrollsToTop = false
        
        self.adjustForPageType()
        self.setupViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.contentInset = UIEdgeInsets.zero
        
        if let initialIndex = self.initialIndex {
         
            let width = self.scrollView.frame.width
            let offset = CGFloat(initialIndex) * width
            
            if (self.scrollView.contentOffset.x != offset) && width > 0 {
                
                let indexPath = IndexPath(item: initialIndex, section: 0)
                self.scrollToItemAtIndexPath(indexPath, animated: true)
                self.initialIndex = nil
            }
        }
    }
    
    fileprivate func removeViewControllers() {
        
        guard let viewControllers = self.viewControllers else {
            
            return
        }
        
        viewControllers.forEach({ (viewController: UIViewController) in
            
            self.pmc_removeChildViewControllerFromView(viewController)
        })
    }
    
    fileprivate func adjustForPageType() {
        
        self.contentViewWidthConstraint.isActive = (self.pageType == .vertical)
        self.contentViewHeightConstraint.isActive = (self.pageType == .horizontal)
        
        self.scrollView.bounces = self.bounces
        self.scrollView.alwaysBounceVertical = (self.pageType == .vertical)
        self.scrollView.alwaysBounceHorizontal = (self.pageType == .horizontal)
    }
    
    fileprivate func setupViewControllers() {
        
        guard let viewControllers = self.viewControllers,
            let contentView = self.contentView else {
            
            return
        }
        
        var previousController: UIViewController? = nil
        viewControllers.forEach({ (viewController: UIViewController) in
            
            self.pmc_addChildViewController(viewController, inView: contentView)
            
            viewController.automaticallyAdjustsScrollViewInsets = false
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            viewController.view.snp_makeConstraints({ (make) in
                
                if self.pageType == .horizontal {
                    
                    make.width.equalTo(self.view)
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
                    
                } else if self.pageType == .vertical {
                    
                    make.height.equalTo(self.view)
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
            })
            
            previousController = viewController
        })
    }
    
    func scrollToItemAtIndexPath(_ indexPath: IndexPath, animated: Bool = true) {
       
        let width = self.scrollView.frame.width
        let offset = CGFloat((indexPath as NSIndexPath).row) * width
        
        if (indexPath as NSIndexPath).row < (self.viewControllers?.count ?? 0) {
         
            let contentOffset = CGPoint(x: offset, y: 0)
            
            self.beginAppearanceTransitionForScrollView(self.scrollView, targetOffset: offset)
            self.scrollView.setContentOffset(contentOffset, animated: animated)
        }
    }
}
