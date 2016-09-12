//
//  PagingTitleViewCell.swift
//  PagingControllerTest
//
//  Created by Tim Johnson on 9/9/16.
//  Copyright © 2016 Kamcord. All rights reserved.
//

import Foundation
import UIKit

class PageTitleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var selectedBackgroundColor: UIColor = UIColor.lightGrayColor() {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedBackgroundColor: UIColor = UIColor.whiteColor()  {
        
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
    
    override var selected: Bool {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var title: String? {
        
        didSet {
            
            self.titleLabel.text = title
        }
    }
    
    private func updateInterfaceElements() {
        
        self.backgroundColor = self.selected ? self.selectedBackgroundColor : self.unselectedBackgroundColor
        self.titleLabel.textColor = self.selected ? self.selectedFontColor : self.unselectedFontColor
        self.titleLabel.font = self.selected ? self.selectedFont : self.unselectedFont
    }
}