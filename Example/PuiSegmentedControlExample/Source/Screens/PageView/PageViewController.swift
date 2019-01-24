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

class PageViewController: UIPageViewController {
    
    // MARK: - Constants
    
    private let segmentedControlMarginLeftRight: CGFloat = 16
    private let segmentedControlMarginBetweenSegmentedControl: CGFloat = 16
    private let segmentedControlMarginTop: CGFloat = 108
    private let segmentedControlHeight: CGFloat = 48
    
    // MARK: - Properties
    
    fileprivate lazy var pages: [UIViewController] = [UIViewController(),
                                                      UIViewController(),
                                                      UIViewController()]
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure 1
        let puiSegmentedControl1 = PuiPageViewSegmentedControl()
        puiSegmentedControl1.frame = CGRect(x: self.segmentedControlMarginLeftRight,
                                           y: self.segmentedControlMarginTop,
                                           width: UIScreen.main.bounds.width - 2 * self.segmentedControlMarginLeftRight,
                                           height: self.segmentedControlHeight)
        self.view.addSubview(puiSegmentedControl1)
        
        puiSegmentedControl1.backgroundCustomColor = UIColor.gray
        puiSegmentedControl1.backgroundCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl1.borderCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl1.seperatorMarginTop = 3
        puiSegmentedControl1.seperatorMarginBottom = 3
        puiSegmentedControl1.isSelectViewAllCornerRadius = true
        puiSegmentedControl1.isSeperatorActive = false
        puiSegmentedControl1.items = ["Tab 1", "Tab 2", "Tab 3"]
        puiSegmentedControl1.selectedIndex = 1
        
        // Configure 2
        let positionY = puiSegmentedControl1.frame.origin.y
            + self.segmentedControlMarginBetweenSegmentedControl
            + self.segmentedControlHeight
        let puiSegmentedControl2 = PuiPageViewSegmentedControl()
        puiSegmentedControl2.frame = CGRect(x: self.segmentedControlMarginLeftRight,
                                           y: positionY,
                                           width: UIScreen.main.bounds.width - 2 * self.segmentedControlMarginLeftRight,
                                           height: self.segmentedControlHeight)
        self.view.addSubview(puiSegmentedControl2)
        
        puiSegmentedControl2.backgroundCustomColor = UIColor.gray
        puiSegmentedControl2.backgroundCornerRadius = puiSegmentedControl2.frame.height / 2
        puiSegmentedControl2.borderCornerRadius = puiSegmentedControl2.frame.height / 2
        puiSegmentedControl2.seperatorMarginTop = 3
        puiSegmentedControl2.seperatorMarginBottom = 3
        puiSegmentedControl2.isSelectViewAllCornerRadius = true
        puiSegmentedControl2.isEqualWidth = false
        puiSegmentedControl2.isSeperatorActive = false
        puiSegmentedControl2.items = ["123 123", "123 123 123", "123"]
        puiSegmentedControl2.selectedIndex = 1
        puiSegmentedControl2.isAnimatedTabTransation = true
        puiSegmentedControl2.animatedTabTransationDuration = 3
        
        // Set background
        self.view.backgroundColor = .white
        
        // Set pages background
        self.pages[0].view.backgroundColor = .blue
        self.pages[1].view.backgroundColor = .lightGray
        self.pages[2].view.backgroundColor = .red
        
        // Delegate, Data source
        self.dataSource = self
        
        // Set ViewController
        self.setViewControllers([self.pages[1]],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        
        // Set segmented control property
//        puiSegmentedControl1.pageViewController = self
        puiSegmentedControl2.pageViewController = self

    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.pages.firstIndex(of: viewController),
            index < self.pages.count - 1 {
            return self.pages[index + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.pages.firstIndex(of: viewController),
            index > 0 {
            return self.pages[index - 1]
        }
        return nil
    }
}

