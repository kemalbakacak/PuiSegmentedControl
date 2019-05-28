//
//  PageViewController.swift
//  PuiSegmentedControlExample
//
//  Created by Kemal Bakacak on 25.12.2018.
//  Copyright © 2018 Kemal Bakacak. All rights reserved.
//

import Foundation
import UIKit
import PuiSegmentedControl

class PageViewController: UIViewController {
	
	// MARK: - Outlets
	
	@IBOutlet weak var segmentedControl: PuiSegmentedControl!
	@IBOutlet weak var pageView: PuiPageViewSegmentedControl!
	
	
	// MARK: - Properties
    
    fileprivate lazy var pages: [UIViewController] = [UIViewController(),
                                                      UIViewController(),
                                                      UIViewController()]
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure 1
        self.segmentedControl.backgroundCustomColor = UIColor.gray
        self.segmentedControl.backgroundCornerRadius = self.segmentedControl.frame.height / 2
        self.segmentedControl.borderCornerRadius = self.segmentedControl.frame.height / 2
        self.segmentedControl.seperatorMarginTop = 3
        self.segmentedControl.seperatorMarginBottom = 3
        self.segmentedControl.isSelectViewAllCornerRadius = true
        self.segmentedControl.isSeperatorActive = false
		self.segmentedControl.isAnimatedTabTransition = true
		self.segmentedControl.animatedTabTransitionDuration = 0.35
        self.segmentedControl.items = ["Tab 1", "Tab 2", "Tab 3"]
        self.segmentedControl.selectedIndex = 1
        
        // Set pages background
        self.pages[0].view.backgroundColor = .blue
        self.pages[1].view.backgroundColor = .lightGray
        self.pages[2].view.backgroundColor = .red
		
		self.pageView.configure(pages: self.pages,
								selectedIndex: 1,
								segmentedControl: self.segmentedControl,
								nextViewSelectionThreshold: 0.8)
		self.pageView.pageViewDelegate = self

    }
}

extension PageViewController: PuiPageViewSegmentedControlDelegate {
	func pageDidChanged(_ index: Int) {
		print("pageDidChanged \(index)")
	}
	
	func pageDidAppear(_ index: Int) {
		print("pageDidAppear \(index)")
	}
}
