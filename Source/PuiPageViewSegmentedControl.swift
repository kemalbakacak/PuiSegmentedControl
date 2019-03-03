//
//  PuiPageViewSegmentedControl.swift
//  PuiSegmentedControl
//
//  Created by Kemal Bakacak on 20.01.2019.
//  Copyright © 2019 Kemal Bakacak. All rights reserved.
//

import Foundation

public protocol PuiScrollViewSegmentedControlDelegate: NSObjectProtocol {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
}

open class PuiPageViewSegmentedControl: PuiSegmentedControl {
    
    // MARK: - Public Properties
    
    public weak var pageViewController: UIPageViewController? {
        didSet {
            self.pageViewController?.delegate = self
            
            // Find scroll view
            for subview in self.pageViewController?.view.subviews ?? [] {
                if let scrollView = subview as? UIScrollView {
                    scrollView.delegate = self
                    self.scrollView = scrollView
                    break
                }
            }
        }
    }
    public weak var scrollViewDelegate: PuiScrollViewSegmentedControlDelegate?
    
    // MARK: - Private Properties
    
    private var scrollView: UIScrollView?
    private var initialScrollViewPosition: CGFloat = 0
    private var isEndedPageViewTransition: Bool = true
    private var ratio: CGFloat?
    
    // MARK: - Override Methods
    
    open override func segmentedControlTransitionBegin(oldValue: Int, newValue: Int) {
        super.segmentedControlTransitionBegin(oldValue: oldValue, newValue: newValue)
        
        // When user tapped to segmented control, then tapped to pageview before animation finished.
        // Segment problem occurs. So I disable to scroll when animation.
        self.scrollView?.isScrollEnabled = false
    }
    
    open override func segmentedControlTransitionEnded(oldValue: Int, newValue: Int) {
        super.segmentedControlTransitionEnded(oldValue: oldValue, newValue: newValue)
        
        // Enable scroll end of animation.
        self.scrollView?.isScrollEnabled = true
    }
}

extension PuiPageViewSegmentedControl: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        // Call super method
        self.pageViewTransitionEnded(isCompleted: completed)
        self.isEndedPageViewTransition = true
    }
    
}

extension PuiPageViewSegmentedControl: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Call scrollview delegate
        self.scrollViewDelegate?.scrollViewWillBeginDragging(scrollView)
        
        // Set initial position
        if self.isEndedPageViewTransition {
            self.initialScrollViewPosition = scrollView.contentOffset.x
            self.isEndedPageViewTransition = false
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Call scrollview delegate
        self.scrollViewDelegate?.scrollViewDidScroll(scrollView)
        
        // Check content offset
        if self.initialScrollViewPosition == scrollView.contentOffset.x {
            return
        }
        
        // Calculate percent of view
        let differenceScrollViewPosition = (self.initialScrollViewPosition - scrollView.contentOffset.x)
        self.ratio = differenceScrollViewPosition / (self.pageViewController?.view.frame.width ?? 0)
        
        // Call super method
        self.scrollSegmentedControl(ratio: self.ratio!)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Call scrollview delegate
        self.scrollViewDelegate?.scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Call scrollview delegate
        self.scrollViewDelegate?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Call scrollview delegate
        self.scrollViewDelegate?.scrollViewWillEndDragging(scrollView,
                                                           withVelocity: velocity,
                                                           targetContentOffset: targetContentOffset)
        
        // Detect bounce effect and return
        if (self.selectedIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) ||
            self.selectedIndex == (self.items.count - 1) && scrollView.contentOffset.x >= scrollView.bounds.size.width {
            return
        }
        
        // Call end dragging method because configure view according to destionation index
        // If ratio more then 0.5, we will move to destination index. 0.5 means 50%
        if self.ratio != nil && (abs(self.ratio!) > 0.5 || abs(velocity.x) > 0.3) {
            self.scrollViewEndDragging()
        }
        
    }
}
