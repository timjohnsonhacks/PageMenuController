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
    
    var selectedBackgroundColor: UIColor = UIColor.lightGray {
        
        didSet {
            
            self.updateInterfaceElements()
        }
    }
    
    var unselectedBackgroundColor: UIColor = UIColor.white  {
        
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
            
            self.updateHighlightedTextColor()
            self.updateInterfaceElements()
        }
    }
    
    override var isSelected: Bool {
        
        didSet {
            
            self.updateInterfaceElements()
            self.titleLabel.isHighlighted = false
        }
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            
            self.titleLabel.isHighlighted = isHighlighted && !self.isSelected
        }
    }
    
    var title: String? {
        
        didSet {
            
            self.titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateHighlightedTextColor()
        self.updateInterfaceElements()
    }
    
    fileprivate func updateHighlightedTextColor() {
        
        self.titleLabel.highlightedTextColor = self.unselectedFontColor.withAlphaComponent(0.3)
    }
    
    fileprivate func updateInterfaceElements() {
        
        self.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.unselectedBackgroundColor
        self.titleLabel.textColor = self.isSelected ? self.selectedFontColor : self.unselectedFontColor
        self.titleLabel.font = self.isSelected ? self.selectedFont : self.unselectedFont
    }
}
