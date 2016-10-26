//
//  PageController+Scrolling.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

enum ScrollDirection: Int {
    
    case none
    case forwards
    case backwards
}

extension PageController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.delegate?.pagingScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.appearingViewController?.endAppearanceTransition()
        self.disappearingViewController?.endAppearanceTransition()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.beginAppearanceTransitionForScrollView(scrollView, targetOffset: targetContentOffset.pointee.x)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.endAppearanceTransitionsForScrollView(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.endAppearanceTransitionsForScrollView(scrollView)
    }
    
    func beginAppearanceTransitionForScrollView(_ scrollView: UIScrollView, targetOffset: CGFloat) {
        
        let currentIndex = self.calculateIndex(targetOffset, scrollView: scrollView)
        
        if let currentViewController = self.viewControllers?[safe: currentIndex],
            let previousController = self.viewControllers?[safe: self.selectedIndex], currentViewController != previousController {
            
            currentViewController.beginAppearanceTransition(true, animated: true)
            previousController.beginAppearanceTransition(false, animated: true)
            
            self.appearingViewController = currentViewController
            self.disappearingViewController = previousController
        }
    }
    
    fileprivate func endAppearanceTransitionsForScrollView(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        let currentIndex = self.calculateIndex(offset, scrollView: scrollView)
        
        if let currentViewController = self.viewControllers?[safe: currentIndex],
            let previousController = self.viewControllers?[safe: self.selectedIndex], currentViewController != previousController {
            
            self.appearingViewController?.endAppearanceTransition()
            self.disappearingViewController?.endAppearanceTransition()
            
            self.appearingViewController = nil
            self.disappearingViewController = nil
            
            self.selectedIndex = currentIndex
            
            self.delegate?.pagingScrollViewDidSelectViewController(currentViewController, atIndex: currentIndex)
        }
    }
    
    fileprivate func calculateIndex(_ offset: CGFloat, scrollView: UIScrollView) -> Int {
        
        let scrollDirection = self.calculateScrollDirection(offset)
        let currentIndex: Int
        
        if scrollDirection == .forwards {
            
            currentIndex = Int(ceil(offset / scrollView.frame.width))
        } else if scrollDirection == .backwards {
            
            currentIndex = Int(floor(offset / scrollView.frame.width))
        } else {
         
            currentIndex = Int(offset / scrollView.frame.width)
        }
        
        return currentIndex
    }
    
    fileprivate func calculateScrollDirection(_ offset: CGFloat) -> ScrollDirection {
        
        var scrollDirection = ScrollDirection.none
        
        if (self.lastOffset > offset) {
            
            scrollDirection = .backwards
        } else if (self.lastOffset < offset) {
            
            scrollDirection = .forwards
        }
        
        self.lastOffset = offset
        
        return scrollDirection
    }
}
