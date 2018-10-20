//
//  PuiTitleLabel.swift
//  PuiSegmentedControl
//
//  Created by Kemal Bakacak on 20.10.2018.
//  Copyright © 2018 Kemal Bakacak. All rights reserved.
//

import Foundation
import UIKit

class PuiTitleLabel: UILabel {
    
    private var customText: String = ""
    private var selectedAttribute: [NSAttributedString.Key: Any] = [:]
    private var unselectedAttribute: [NSAttributedString.Key: Any]?
    
    public var isSelected: Bool = false {
        didSet {
            self.configureTextAttribute()
        }
    }
    
    // MARK: - Init methods
    
    init(text: String,
         selectedAttribute: [NSAttributedString.Key: Any],
         unselectedAttribute: [NSAttributedString.Key: Any]?) {
        super.init(frame: CGRect.zero)
        
        self.customText = text
        self.selectedAttribute = selectedAttribute
        self.unselectedAttribute = unselectedAttribute
        
        // Set autolayout proporty
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Set text properties
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Helper methods
    
    // Set attribute string
    private func configureTextAttribute() {
        // Set string with attribute
        self.attributedText = NSAttributedString(string: self.customText, attributes: self.getCurrentAttribute())
    }
    
    // Get attribute according to selected property.
    private func getCurrentAttribute() -> [NSAttributedString.Key: Any] {
        if let unselectedTextAttributes = self.unselectedAttribute, !self.isSelected {
            return unselectedTextAttributes
        } else {
            return self.selectedAttribute
        }
    }
}

