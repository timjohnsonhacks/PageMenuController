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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.delegate?.pagingScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.appearingViewController?.endAppearanceTransition()
        self.disappearingViewController?.endAppearanceTransition()
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentIndex = self.calculateIndex(targetContentOffset.memory.x, scrollView: scrollView)
        
        if let currentViewController = self.viewControllers?[safe: currentIndex],
            previousController = self.viewControllers?[safe: self.selectedIndex] where currentViewController != previousController {
            
            currentViewController.beginAppearanceTransition(true, animated: true)
            previousController.beginAppearanceTransition(false, animated: true)
            
            self.appearingViewController = currentViewController
            self.disappearingViewController = previousController
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        let currentIndex = self.calculateIndex(offset, scrollView: scrollView)
        
        if let currentViewController = self.viewControllers?[safe: currentIndex],
            previousController = self.viewControllers?[safe: self.selectedIndex] where currentViewController != previousController {
            
            self.appearingViewController?.endAppearanceTransition()
            self.disappearingViewController?.endAppearanceTransition()
            
            self.appearingViewController = nil
            self.disappearingViewController = nil
            
            self.selectedIndex = currentIndex
        }
    }
    
    private func calculateIndex(offset: CGFloat, scrollView: UIScrollView) -> Int {
        
        let scrollDirection = self.calculateScrollDirection(offset)
        let currentIndex: Int
        
        if scrollDirection == .Forwards {
            
            currentIndex = Int(ceil(offset / CGRectGetWidth(scrollView.frame)))
        } else if scrollDirection == .Backwards {
            
            currentIndex = Int(floor(offset / CGRectGetWidth(scrollView.frame)))
        } else {
         
            currentIndex = Int(offset / CGRectGetWidth(scrollView.frame))
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