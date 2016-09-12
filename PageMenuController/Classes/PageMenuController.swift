//
//  PageMenuController.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

public class PageMenuController: UIViewController {
    
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var titleContainerHeightConstraint: NSLayoutConstraint!
    
    private var pageTitleView: PageTitleView?
    private var pageController: PageController?
    
    public var titleContainerHeight: CGFloat? {
        
        didSet {
        
            guard let height = titleContainerHeight else {
                
                return
            }
            
            self.titleContainerHeightConstraint.constant = height
        }
    }
    
    public var viewControllers: [UIViewController]? {
        
        didSet {
            
            self.pageController?.viewControllers = viewControllers
            self.updateTitles()
        }
    }
    
    public init() {
        super.init(nibName: "PageMenuController", bundle: NSBundle.pageMenuBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPageTitleView()
        self.addPageController()
    }
    
    private func addPageTitleView() {
        
        if let pageTitleView = PageTitleView.viewFromNib() {
            
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
        self.addChildViewController(pageController, inView: self.pageContainerView)
        
        pageController.view.snp_makeConstraints { (make) in
            
            make.edges.equalTo(self.pageContainerView)
        }
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
}