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
    static let DefaultSeparatorHeight: CGFloat = 1.0 / UIScreen.main.scale
    
    static let DefaultAnimationDuration: TimeInterval = 0.3
}

public protocol PageMenuControllerDelegate: class {
    
    func pageMenuDidSelectController(_ controller: UIViewController, atIndex index: Int)
    func pageMenuControllerIsUpdatingBars(_ hide: Bool)
}

open class PageMenuController: UIViewController {
    
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var pageContainerView: UIView!
    @IBOutlet fileprivate weak var titleContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var separatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var separatorView: UIView!
    
    @IBOutlet fileprivate weak var titleContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var pageContainerToSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var pageContainerToTopConstraint: NSLayoutConstraint!
    
    internal var pageTitleView: PageTitleView?
    fileprivate var pageController: PageController?
    
    internal var KVOContext: UInt8 = 1
    
    open var delegate: PageMenuControllerDelegate?
    
    open var titleContainerHeight: CGFloat = Constants.DefaultTitleHeight {
        
        didSet {
            
            self.updateTitleViewHeight()
        }
    }
    
    open var hidesSeparator: Bool = false {
        
        didSet {
            
            self.updateSeparatorHeight()
        }
    }
    
    open var bounces: Bool = true {
        
        didSet {
            
            self.pageController?.bounces = bounces
        }
    }
    
    open var backgroundColor: UIColor = UIColor.white {
        
        didSet {
            
            self.pageController?.backgroundColor = backgroundColor
        }
    }
    
    open var extendEdgesUnderTitleBar: Bool = false {
        
        didSet {
            
            self.updatePageContainerTopConstraint()
        }
    }
    
    open var separatorColor: UIColor = UIColor.black {
        
        didSet {
            
            if self.separatorView != nil {
             
                self.separatorView.backgroundColor = separatorColor
            }
        }
    }
    
    open var selectionIndicatorColor: UIColor = UIColor.darkGray {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var selectedBackgroundColor: UIColor = UIColor.lightGray {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var unselectedBackgroundColor: UIColor = UIColor.white {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var selectedFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var unselectedFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var selectedFontColor: UIColor = UIColor.black {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var unselectedFontColor: UIColor = UIColor.black {
        
        didSet {
            
            self.updateTitleViewInterface()
        }
    }
    
    open var viewControllers: [UIViewController]? {
        
        didSet {
            
            self.updateObserversForViewControllers(self.pageController?.viewControllers, addObservers: viewControllers)
            
            self.pageController?.viewControllers = viewControllers
            self.updateTitles()
        }
    }
    
    open var selectedIndex: Int {
        
        get {
            
            return self.pageController?.selectedIndex ?? 0
        }
    }
    
    open var initialIndex: Int? {
        
        didSet {
            
            self.pageController?.initialIndex = initialIndex
        }
    }
    
    public init() {
        super.init(nibName: "PageMenuController", bundle: Bundle.pmc_pageMenuResourceBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.parent?.automaticallyAdjustsScrollViewInsets = false
        
        self.initializeInterface()
        self.updatePageContainerTopConstraint()
        self.addPageTitleView()
        self.addPageController()
    }
    
    fileprivate func initializeInterface() {
        
        self.updateTitleViewHeight()
        
        self.separatorView.backgroundColor = self.separatorColor
        self.updateSeparatorHeight()
    }
    
    fileprivate func updateTitleViewHeight() {
         
        self.performViewUpdatesOnMainThread() {
            
            self.titleContainerHeightConstraint.constant = self.titleContainerHeight
        }
    }
    
    fileprivate func updateSeparatorHeight() {
         
        self.performViewUpdatesOnMainThread() {
            
            self.separatorViewHeightConstraint.constant = self.hidesSeparator ? 0.0 : Constants.DefaultSeparatorHeight
        }
    }
    
    fileprivate func updatePageContainerTopConstraint() {
        
        self.performViewUpdatesOnMainThread() {
            
            self.pageContainerToTopConstraint.isActive = self.extendEdgesUnderTitleBar
            self.pageContainerToSeparatorConstraint.isActive = !self.extendEdgesUnderTitleBar
        }
    }
    
    fileprivate func addPageTitleView() {
        
        if let pageTitleView = PageTitleView.pmc_viewFromNib() {
            
            pageTitleView.delegate = self
            self.titleContainerView.addSubview(pageTitleView)
            
            pageTitleView.snp_makeConstraints({ (make) in
                
                make.edges.equalTo(self.titleContainerView)
            })
            
            self.pageTitleView = pageTitleView
            self.updateTitles()
            self.updateTitleViewInterface()
        }
    }
    
    fileprivate func addPageController() {
        
        let pageController = PageController()
        
        pageController.backgroundColor = self.backgroundColor
        pageController.bounces = self.bounces
        
        pageController.delegate = self
        pageController.viewControllers = self.viewControllers
        self.pmc_addChildViewController(pageController, inView: self.pageContainerView)
        
        pageController.view.snp_makeConstraints { (make) in
            
            make.edges.equalTo(self.pageContainerView)
        }
        
        self.pageController = pageController
    }
    
    fileprivate func updateTitleViewInterface() {
        
        self.pageTitleView?.selectionIndicatorColor = self.selectionIndicatorColor
        self.pageTitleView?.selectedBackgroundColor = self.selectedBackgroundColor
        self.pageTitleView?.unselectedBackgroundColor = self.unselectedBackgroundColor
        self.pageTitleView?.selectedFont = self.selectedFont
        self.pageTitleView?.unselectedFont = self.unselectedFont
        self.pageTitleView?.selectedFontColor = self.selectedFontColor
        self.pageTitleView?.unselectedFontColor = self.unselectedFontColor
    }
    
    fileprivate func updateTitles() {
        
        var titles = [String]()
        
        self.viewControllers?.forEach({ titles.append($0.title ?? "") })
        self.pageTitleView?.titles = titles
    }
    
    open func hideTopBar() {
        
        self.toggleTopBar(true)
    }
    
    open func showTopBar() {
        
        self.toggleTopBar(false)
    }
    
    fileprivate func toggleTopBar(_ hide: Bool) {
        
        UIView.animate(withDuration: Constants.DefaultAnimationDuration) {
            
            self.delegate?.pageMenuControllerIsUpdatingBars(hide)
            
            if self.isViewLoaded {
                
                self.titleContainerTopConstraint.constant = hide ? -(self.titleContainerHeightConstraint.constant + self.separatorViewHeightConstraint.constant) : 0
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func performViewUpdatesOnMainThread(_ block: @escaping (() -> Void)) {
        
        if self.isViewLoaded {
             
            DispatchQueue.main.async(execute: {
                
                block()
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension PageMenuController: PageControllerDelegate {
    
    func pagingScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.pageTitleView?.didScrollToOffset(scrollView.contentOffset.x, contentSize: scrollView.contentSize.width)
    }
    
    func pagingScrollViewDidSelectViewController(_ controller: UIViewController, atIndex index: Int) {
        
        self.delegate?.pageMenuDidSelectController(controller, atIndex: index)
    }
}

extension PageMenuController: PageTitleViewDelegate {
    
    func pageTitleViewDidSelectItemAtIndexPath(_ indexPath: IndexPath) {
        
        self.pageController?.scrollToItemAtIndexPath(indexPath)
    }
}
