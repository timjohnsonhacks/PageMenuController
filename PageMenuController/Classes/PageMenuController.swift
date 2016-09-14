//
//  PageMenuController.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

private struct Constants {
    
    static let DefaultTitleHeight: CGFloat = 64
    static let DefaultSeparatorHeight: CGFloat = 1.0 / UIScreen.mainScreen().scale
    
    static let DefaultAnimationDuration: NSTimeInterval = 0.3
}

public protocol PageMenuControllerDelegate: class {
    
    func pageMenuDidSelectController(controller: UIViewController, atIndex index: Int)
}

public class PageMenuController: UIViewController {
    
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var titleContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separatorView: UIView!
    
    @IBOutlet private weak var titleContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet private var pageContainerToSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet private var pageContainerToTopConstraint: NSLayoutConstraint!
    
    internal var pageTitleView: PageTitleView?
    private var pageController: PageController?
    
    internal var KVOContext: UInt8 = 1
    
    public var delegate: PageMenuControllerDelegate?
    
    public var titleContainerHeight: CGFloat = Constants.DefaultTitleHeight {
        
        didSet {
            
            self.updateTitleViewHeight()
        }
    }
    
    public var hidesSeparator: Bool = false {
        
        didSet {
            
            self.updateSeparatorHeight()
        }
    }
    
    public var extendEdgesUnderTitleBar: Bool = false {
        
        didSet {
            
            self.updatePageContainerTopConstraint()
        }
    }
    
    public var separatorColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            if self.separatorView != nil {
             
                self.separatorView.backgroundColor = separatorColor
            }
        }
    }
    
    public var selectionIndicatorColor: UIColor = UIColor.darkGrayColor() {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var selectedBackgroundColor: UIColor = UIColor.lightGrayColor() {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var unselectedBackgroundColor: UIColor = UIColor.whiteColor() {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var selectedFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var unselectedFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var selectedFontColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var unselectedFontColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    public var viewControllers: [UIViewController]? {
        
        didSet {
            
            self.updateObserversForViewControllers(self.pageController?.viewControllers, addObservers: viewControllers)
            
            self.pageController?.viewControllers = viewControllers
            self.updateTitles()
        }
    }
    
    public var selectedIndex: Int {
        
        get {
            
            return self.pageController?.selectedIndex ?? 0
        }
    }
    
    public var initialIndex: Int? {
        
        didSet {
            
            self.pageController?.initialIndex = initialIndex
        }
    }
    
    public init() {
        super.init(nibName: "PageMenuController", bundle: NSBundle.pmc_pageMenuResourceBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentViewController?.automaticallyAdjustsScrollViewInsets = false
        
        self.initializeInterface()
        self.updatePageContainerTopConstraint()
        self.addPageTitleView()
        self.addPageController()
    }
    
    private func initializeInterface() {
        
        self.updateTitleViewHeight()
        
        self.separatorView.backgroundColor = self.separatorColor
        self.updateSeparatorHeight()
    }
    
    private func updateTitleViewHeight() {
        
        self.performViewUpdatesOnMainThread {
            
            self.titleContainerHeightConstraint.constant = self.titleContainerHeight
        }
    }
    
    private func updateSeparatorHeight() {
        
        self.performViewUpdatesOnMainThread { 
         
            self.separatorViewHeightConstraint.constant = self.hidesSeparator ? 0.0 : Constants.DefaultSeparatorHeight
        }
    }
    
    private func updatePageContainerTopConstraint() {
                
        self.performViewUpdatesOnMainThread{
            
            self.pageContainerToTopConstraint.active = self.extendEdgesUnderTitleBar
            self.pageContainerToSeparatorConstraint.active = !self.extendEdgesUnderTitleBar
        }
    }
    
    private func addPageTitleView() {
        
        if let pageTitleView = PageTitleView.pmc_viewFromNib() {
            
            pageTitleView.delegate = self
            self.titleContainerView.addSubview(pageTitleView)
            
            pageTitleView.snp_makeConstraints(closure: { (make) in
                
                make.edges.equalTo(self.titleContainerView)
            })
            
            self.pageTitleView = pageTitleView
            self.updateTitles()
            self.updateTitleViewInterface()
        }
    }
    
    private func addPageController() {
        
        let pageController = PageController()
        
        pageController.delegate = self
        pageController.viewControllers = self.viewControllers
        self.pmc_addChildViewController(pageController, inView: self.pageContainerView)
        
        pageController.view.snp_makeConstraints { (make) in
            
            make.edges.equalTo(self.pageContainerView)
        }
        
        self.pageController = pageController
    }
    
    private func updateTitleViewInterface() {
        
        self.pageTitleView?.selectionIndicatorColor = self.selectionIndicatorColor
        self.pageTitleView?.selectedBackgroundColor = self.selectedBackgroundColor
        self.pageTitleView?.unselectedBackgroundColor = self.unselectedBackgroundColor
        self.pageTitleView?.selectedFont = self.selectedFont
        self.pageTitleView?.unselectedFont = self.unselectedFont
        self.pageTitleView?.selectedFontColor = self.selectedFontColor
        self.pageTitleView?.unselectedFontColor = self.unselectedFontColor
    }
    
    private func updateTitles() {
        
        var titles = [String]()
        
        self.viewControllers?.forEach({ titles.append($0.title ?? "") })
        self.pageTitleView?.titles = titles
    }
    
    public func hideTopBar() {
        
        self.toggleTopBar(true)
    }
    
    public func showTopBar() {
        
        self.toggleTopBar(false)
    }
    
    private func toggleTopBar(hide: Bool) {
        
        UIView.animateWithDuration(Constants.DefaultAnimationDuration) {
            
            if self.isViewLoaded() {
                
                self.titleContainerTopConstraint.constant = hide ? -(self.titleContainerHeightConstraint.constant + self.separatorViewHeightConstraint.constant) : 0
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func performViewUpdatesOnMainThread(block: (() -> Void)) {
        
        if self.isViewLoaded() {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                block()
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension PageMenuController: PageControllerDelegate {
    
    func pagingScrollViewDidScroll(scrollView: UIScrollView) {
        
        self.pageTitleView?.didScrollToOffset(scrollView.contentOffset.x, contentSize: scrollView.contentSize.width)
    }
    
    func pagingScrollViewDidSelectViewController(controller: UIViewController, atIndex index: Int) {
        
        self.delegate?.pageMenuDidSelectController(controller, atIndex: index)
    }
}

extension PageMenuController: PageTitleViewDelegate {
    
    func pageTitleViewDidSelectItemAtIndexPath(indexPath: NSIndexPath) {
        
        self.pageController?.scrollToItemAtIndexPath(indexPath)
    }
}