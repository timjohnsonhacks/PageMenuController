//
//  PageMenuController+Observering.swift
//  Pods
//
//  Created by Tim Johnson on 9/12/16.
//
//

import Foundation
import UIKit

private struct Constants {
    
    static let TitleKeyPath = "title"
}

extension PageMenuController {
    
    func updateObserversForViewControllers(removeObservers: [UIViewController]?, addObservers: [UIViewController]?) {
        
        removeObservers?.forEach({ $0.removeObserver(self, forKeyPath: Constants.TitleKeyPath, context: &KVOContext) })
        
        addObservers?.forEach({ $0.addObserver(self, forKeyPath: Constants.TitleKeyPath, options: .New, context: &KVOContext) })
    }
    
    func addObserverForViewController(viewController: UIViewController) {
        
        viewController.addObserver(self, forKeyPath: Constants.TitleKeyPath, options: .New, context: &KVOContext)
    }
    
    func removeObserverForViewController(viewController: UIViewController) {
        
        viewController.removeObserver(self, forKeyPath: Constants.TitleKeyPath, context: &KVOContext)
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let keyPath = keyPath,
            viewController = object as? UIViewController,
            viewControllerIndex = self.viewControllers?.indexOf(viewController) where keyPath == Constants.TitleKeyPath && context == &KVOContext {
            
            self.pageTitleView?.updateCellAtIndex(viewControllerIndex)
        }
    }
}