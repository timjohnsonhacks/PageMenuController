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
        
        addObservers?.forEach({ $0.addObserver(self, forKeyPath: Constants.TitleKeyPath, options: .new, context: &KVOContext) })
    }
    
    func addObserverForViewController(viewController: UIViewController) {
        
        viewController.addObserver(self, forKeyPath: Constants.TitleKeyPath, options: .new, context: &KVOContext)
    }
    
    func removeObserverForViewController(viewController: UIViewController) {
        
        viewController.removeObserver(self, forKeyPath: Constants.TitleKeyPath, context: &KVOContext)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let keyPath = keyPath,
            let viewController = object as? UIViewController,
            let viewControllerIndex = self.viewControllers?.index(of: viewController), keyPath == Constants.TitleKeyPath && context == &KVOContext {
            
            self.pageTitleView?.updateCellAtIndex(index: viewControllerIndex, title: viewController.title)
        }
    }
}
