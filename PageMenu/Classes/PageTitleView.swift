//
//  PagingTitleView.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

class PageTitleView: UIView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var selectionIndicator: UIView!
    @IBOutlet private weak var selectionIndicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectionIndicatorLeadingConstraint: NSLayoutConstraint!
    
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
        
        self.selectionIndicatorWidthConstraint.constant = CGRectGetWidth(self.collectionView.frame) / CGFloat(self.titles?.count ?? 1)
        self.updateSelectedContent()
    }
    
    private func setupCollectionView() {
        
        self.collectionView.registerNib(PageTitleViewCell.nib, forCellWithReuseIdentifier: PageTitleViewCell.nibName)
    }
    
    private func updateInterfaceElements() {
        
        self.selectionIndicator.backgroundColor = self.selectionIndicatorColor
        
        if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems()?.last,
            selectedCell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as? PageTitleViewCell {
            
            selectedCell.selectedFont = self.selectedFont
            selectedCell.selectedFontColor = self.selectedFontColor
            selectedCell.selectedBackgroundColor = self.selectedBackgroundColor
            
            selectedCell.unselectedFont = self.unselectedFont
            selectedCell.unselectedFontColor = self.unselectedFontColor
            selectedCell.unselectedBackgroundColor = self.unselectedBackgroundColor
        }
    }
    
    func didScrollToOffset(offset: CGFloat, contentSize: CGFloat) {
        
        let sizeRatio = CGRectGetWidth(self.frame) / contentSize
        let relativeOffset = offset * sizeRatio
        
        self.selectionIndicatorLeadingConstraint.constant = relativeOffset
        self.updateSelectedContent()
    }
    
    private func updateSelectedContent() {
        
        let relativeOffset = self.selectionIndicatorLeadingConstraint.constant
        let selectionOffset = relativeOffset + (self.selectionIndicatorWidthConstraint.constant / 2)
        let selectedPoint = CGPointMake(selectionOffset, 0)
        if let indexPath = self.collectionView.indexPathForItemAtPoint(selectedPoint) {
            
            self.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .CenteredVertically)
        }
    }
}

extension PageTitleView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titles?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let pageTitleCell = collectionView.dequeueReusableCellWithReuseIdentifier(PageTitleViewCell.nibName, forIndexPath: indexPath) as! PageTitleViewCell
        
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
}