//
//  PuiPageViewSegmentedControl.swift
//  PuiSegmentedControl
//
//  Created by Kemal Bakacak on 20.01.2019.
//  Copyright © 2019 Kemal Bakacak. All rights reserved.
//

import Foundation

open class PuiPageViewSegmentedControl: PuiSegmentedControl {
    
    // MARK: - Public Properties
    
    public weak var pageViewController: UIPageViewController? {
        didSet {
            self.pageViewController?.delegate = self
            
            // Find scroll view
            for subview in self.pageViewController?.view.subviews ?? [] {
                if let scrollView = subview as? UIScrollView {
                    scrollView.delegate = self
                    break
                }
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var initialScrollViewPosition: CGFloat = 0
    private var transactionCompleted: Bool = true
}

extension PuiPageViewSegmentedControl: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        self.transactionCompleted = true
        
        // Call super method
        self.pageViewTransactionEnded(isCompleted: completed)
    }
}

extension PuiPageViewSegmentedControl: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.transactionCompleted {
            self.initialScrollViewPosition = scrollView.contentOffset.x
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.initialScrollViewPosition == scrollView.contentOffset.x {
            return
        }
        
        // Calculate percent of view
        let differenceScrollViewPosition = (self.initialScrollViewPosition - scrollView.contentOffset.x)
        let ratio = differenceScrollViewPosition / (self.pageViewController?.view.frame.width ?? 0)
        
        // Call super method
        self.scrollSegmentedControl(ratio: ratio)
    }
    
}
