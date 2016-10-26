//
//  PagingTitleView.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

protocol PageTitleViewDelegate: class {
    
    func pageTitleViewDidSelectItemAtIndexPath(_ indexPath: IndexPath)
}

class PageTitleView: UIView {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var selectionIndicator: UIView!
    @IBOutlet fileprivate weak var selectionIndicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var selectionIndicatorLeadingConstraint: NSLayoutConstraint!
    
    weak var delegate: PageTitleViewDelegate?
    
    var selectionIndicatorColor: UIColor = UIColor.darkGray {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var selectedBackgroundColor: UIColor = UIColor.lightGray {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedBackgroundColor: UIColor = UIColor.white {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var selectedFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var selectedFontColor: UIColor = UIColor.black {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedFontColor: UIColor = UIColor.black {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var titles: [String]? {
        
        didSet {
            
            self.updateSelectionIndicatorWidth()
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
        self.updateInterfaceElements()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateSelectionIndicatorWidth()
        self.updateSelectedContent()
    }
    
    fileprivate func setupCollectionView() {
        
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.scrollsToTop = false
        self.collectionView.register(PageTitleViewCell.pmc_nib, forCellWithReuseIdentifier: PageTitleViewCell.pmc_nibName)
    }
    
    fileprivate func updateSelectionIndicatorWidth() {
        
        let count = self.titles?.count ?? 1
        self.selectionIndicatorWidthConstraint.constant = count > 1 ? self.collectionView.frame.width / CGFloat(count) : 0
    }
    
    fileprivate func updateInterfaceElements() {
        
        self.selectionIndicator.backgroundColor = self.selectionIndicatorColor
        
        for case let cell as PageTitleViewCell in self.collectionView.visibleCells {
             
            cell.selectedFont = self.selectedFont
            cell.selectedFontColor = self.selectedFontColor
            cell.selectedBackgroundColor = self.selectedBackgroundColor
            
            cell.unselectedFont = self.unselectedFont
            cell.unselectedFontColor = self.unselectedFontColor
            cell.unselectedBackgroundColor = self.unselectedBackgroundColor
        }
    }
    
    func didScrollToOffset(_ offset: CGFloat, contentSize: CGFloat) {
        
        if contentSize > 0 {
         
            let sizeRatio = self.frame.width / contentSize
            let relativeOffset = offset * sizeRatio
            
            self.selectionIndicatorLeadingConstraint.constant = relativeOffset
            self.updateSelectedContent()
        }
    }
    
    func updateCellAtIndex(_ index: Int, title: String?) {

        guard let title = title, (self.titles?.count ?? 0) > index else {
            
            return
        }
        
        self.titles?[index] = title
        self.updateSelectedContent()
    }
    
    fileprivate func updateSelectedContent() {
        
        let relativeOffset = self.selectionIndicatorLeadingConstraint.constant
        let selectionOffset = relativeOffset + (self.selectionIndicatorWidthConstraint.constant / 2)
        let selectedPoint = CGPoint(x: selectionOffset, y: 0)
        if let indexPath = self.collectionView.indexPathForItem(at: selectedPoint) {
            
            if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.last, selectedIndexPath != indexPath {
                
                self.collectionView.deselectItem(at: selectedIndexPath, animated: false)
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            } else if self.collectionView.indexPathsForSelectedItems?.last == nil {
                
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
        }
    }
}

extension PageTitleView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pageTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTitleViewCell.pmc_nibName, for: indexPath as IndexPath) as! PageTitleViewCell
        
        let title = self.titles?[safe: indexPath.row]
        pageTitleCell.title = title
        
        pageTitleCell.selectedBackgroundColor = self.selectedBackgroundColor
        pageTitleCell.unselectedBackgroundColor = self.unselectedBackgroundColor
        
        pageTitleCell.selectedFontColor = self.selectedFontColor
        pageTitleCell.unselectedFontColor = self.unselectedFontColor
        
        pageTitleCell.selectedFont = self.selectedFont
        pageTitleCell.unselectedFont = self.unselectedFont
        
        return pageTitleCell
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titles?.count ?? 0
    }
}

extension PageTitleView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        let cellWidth = width / CGFloat(self.titles?.count ?? 1)
        
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        self.delegate?.pageTitleViewDidSelectItemAtIndexPath(indexPath)
        
        return false
    }
}
