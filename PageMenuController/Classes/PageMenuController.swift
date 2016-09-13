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
    
    internal var pageTitleView: PageTitleView?
    private var pageController: PageController?
    
    internal var KVOContext: UInt8 = 1
    
    public var delegate: PageMenuControllerDelegate?
    
    public var titleContainerHeight: CGFloat = Constants.DefaultTitleHeight {
        
        didSet {
            
            self.titleContainerHeightConstraint.constant = titleContainerHeight
        }
    }
    
    public var separatorColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            self.separatorView.backgroundColor = separatorColor
        }
    }
    
    public var selectionIndicatorColor: UIColor = UIColor.darkGrayColor() {
        
        didSet {
            
            self.pageTitleView?.selectionIndicatorColor = selectionIndicatorColor
        }
    }
    
    var selectedBackgroundColor: UIColor = UIColor.lightGrayColor() {
        
        didSet {
            
            self.pageTitleView?.selectedBackgroundColor = selectedBackgroundColor
        }
    }
    
    var unselectedBackgroundColor: UIColor = UIColor.whiteColor() {
        
        didSet {
            
            self.pageTitleView?.unselectedBackgroundColor = unselectedBackgroundColor
        }
    }
    
    var selectedFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        
        didSet {
            
            self.pageTitleView?.selectedFont = selectedFont
        }
    }
    
    var unselectedFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        
        didSet {
            
            self.pageTitleView?.unselectedFont = unselectedFont
        }
    }
    
    var selectedFontColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            self.pageTitleView?.selectedFontColor = selectedFontColor
        }
    }
    
    var unselectedFontColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            self.pageTitleView?.unselectedFontColor = unselectedFontColor
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
    
    public init() {
        super.init(nibName: "PageMenuController", bundle: NSBundle.pmc_pageMenuBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSeparatorView()
        self.addPageTitleView()
        self.addPageController()
    }
    
    private func setupSeparatorView() {
        
        self.separatorViewHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        self.separatorView.backgroundColor = self.separatorColor
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
    
    private func updateTitles() {
        
        var titles = [String]()
        
        self.viewControllers?.forEach({ titles.append($0.title ?? "") })
        self.pageTitleView?.titles = titles
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