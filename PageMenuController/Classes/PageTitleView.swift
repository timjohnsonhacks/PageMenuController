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
    
    func pageTitleViewDidSelectItemAtIndexPath(indexPath: NSIndexPath)
}

class PageTitleView: UIView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var selectionIndicator: UIView!
    @IBOutlet private weak var selectionIndicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectionIndicatorLeadingConstraint: NSLayoutConstraint!
    
    weak var delegate: PageTitleViewDelegate?
    
    var selectionIndicatorColor: UIColor = UIColor.darkGrayColor() {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var selectedBackgroundColor: UIColor = UIColor.lightGrayColor() {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedBackgroundColor: UIColor = UIColor.whiteColor() {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var selectedFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var selectedFontColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedFontColor: UIColor = UIColor.blackColor() {
        
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
    
    private func setupCollectionView() {
        
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.scrollsToTop = false
        self.collectionView.registerNib(PageTitleViewCell.pmc_nib, forCellWithReuseIdentifier: PageTitleViewCell.pmc_nibName)
    }
    
    private func updateSelectionIndicatorWidth() {
        
        let count = self.titles?.count ?? 1
        self.selectionIndicatorWidthConstraint.constant = count > 1 ? CGRectGetWidth(self.collectionView.frame) / CGFloat(count) : 0
    }
    
    private func updateInterfaceElements() {
        
        self.selectionIndicator.backgroundColor = self.selectionIndicatorColor
        
        for case let cell as PageTitleViewCell in self.collectionView.visibleCells() {
             
            cell.selectedFont = self.selectedFont
            cell.selectedFontColor = self.selectedFontColor
            cell.selectedBackgroundColor = self.selectedBackgroundColor
            
            cell.unselectedFont = self.unselectedFont
            cell.unselectedFontColor = self.unselectedFontColor
            cell.unselectedBackgroundColor = self.unselectedBackgroundColor
        }
    }
    
    func didScrollToOffset(offset: CGFloat, contentSize: CGFloat) {
        
        if contentSize > 0 {
         
            let sizeRatio = CGRectGetWidth(self.frame) / contentSize
            let relativeOffset = offset * sizeRatio
            
            self.selectionIndicatorLeadingConstraint.constant = relativeOffset
            self.updateSelectedContent()
        }
    }
    
    func updateCellAtIndex(index: Int, title: String?) {

        guard let title = title where self.titles?.count > index else {
            
            return
        }
        
        self.titles?[index] = title
    }
    
    private func updateSelectedContent() {
        
        let relativeOffset = self.selectionIndicatorLeadingConstraint.constant
        let selectionOffset = relativeOffset + (self.selectionIndicatorWidthConstraint.constant / 2)
        let selectedPoint = CGPointMake(selectionOffset, 0)
        if let indexPath = self.collectionView.indexPathForItemAtPoint(selectedPoint) {
            
            if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems()?.last where selectedIndexPath != indexPath {
                
                self.collectionView.deselectItemAtIndexPath(selectedIndexPath, animated: false)
                self.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .CenteredVertically)
            } else if self.collectionView.indexPathsForSelectedItems()?.last == nil {
                
                self.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .CenteredVertically)
            }
        }
    }
}

extension PageTitleView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titles?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let pageTitleCell = collectionView.dequeueReusableCellWithReuseIdentifier(PageTitleViewCell.pmc_nibName, forIndexPath: indexPath) as! PageTitleViewCell
        
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
}

extension PageTitleView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = CGRectGetWidth(collectionView.frame)
        let height = CGRectGetHeight(collectionView.frame)
        
        let cellWidth = width / CGFloat(self.titles?.count ?? 1)
        
        return CGSizeMake(cellWidth, height)
    }
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        self.delegate?.pageTitleViewDidSelectItemAtIndexPath(indexPath)
        
        return false
    }
}