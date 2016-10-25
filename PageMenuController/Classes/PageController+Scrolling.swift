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
    
    case None
    case Forwards
    case Backwards
}

extension PageController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.delegate?.pagingScrollViewDidScroll(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.appearingViewController?.endAppearanceTransition()
        self.disappearingViewController?.endAppearanceTransition()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.beginAppearanceTransitionForScrollView(scrollView: scrollView, targetOffset: targetContentOffset.pointee.x)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.endAppearanceTransitionsForScrollView(scrollView: scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.endAppearanceTransitionsForScrollView(scrollView: scrollView)
    }
    
    func beginAppearanceTransitionForScrollView(scrollView: UIScrollView, targetOffset: CGFloat) {
        
        let currentIndex = self.calculateIndex(offset: targetOffset, scrollView: scrollView)
        
        if let currentViewController = self.viewControllers?[safe: currentIndex],
            let previousController = self.viewControllers?[safe: self.selectedIndex], currentViewController != previousController {
            
            currentViewController.beginAppearanceTransition(true, animated: true)
            previousController.beginAppearanceTransition(false, animated: true)
            
            self.appearingViewController = currentViewController
            self.disappearingViewController = previousController
        }
    }
    
    private func endAppearanceTransitionsForScrollView(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        let currentIndex = self.calculateIndex(offset: offset, scrollView: scrollView)
        
        if let currentViewController = self.viewControllers?[safe: currentIndex],
            let previousController = self.viewControllers?[safe: self.selectedIndex], currentViewController != previousController {
            
            self.appearingViewController?.endAppearanceTransition()
            self.disappearingViewController?.endAppearanceTransition()
            
            self.appearingViewController = nil
            self.disappearingViewController = nil
            
            self.selectedIndex = currentIndex
            
            self.delegate?.pagingScrollViewDidSelectViewController(controller: currentViewController, atIndex: currentIndex)
        }
    }
    
    private func calculateIndex(offset: CGFloat, scrollView: UIScrollView) -> Int {
        
        let scrollDirection = self.calculateScrollDirection(offset: offset)
        let currentIndex: Int
        
        if scrollDirection == .Forwards {
            
            currentIndex = Int(ceil(offset / scrollView.frame.width))
        } else if scrollDirection == .Backwards {
            
            currentIndex = Int(floor(offset / scrollView.frame.width))
        } else {
         
            currentIndex = Int(offset / scrollView.frame.width)
        }
        
        return currentIndex
    }
    
    private func calculateScrollDirection(offset: CGFloat) -> ScrollDirection {
        
        var scrollDirection = ScrollDirection.None
        
        if (self.lastOffset > offset) {
            
            scrollDirection = .Backwards
        } else if (self.lastOffset < offset) {
            
            scrollDirection = .Forwards
        }
        
        self.lastOffset = offset
        
        return scrollDirection
    }
}
