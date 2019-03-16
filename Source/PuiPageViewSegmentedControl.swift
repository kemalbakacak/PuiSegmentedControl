//
//  PuiPageViewSegmentedControl.swift
//  PuiSegmentedControl
//
//  Created by Kemal Bakacak on 20.01.2019.
//  Copyright © 2019 Kemal Bakacak. All rights reserved.
//

import Foundation

open class PuiPageViewSegmentedControl: PuiSegmentedControl {
	
	// MARK: Delegate
	
	private weak var pageViewOriginalDelegate: UIPageViewControllerDelegate?
	private weak var scrollViewOriginalDelegate: UIScrollViewDelegate?
    
    // MARK: - Public Properties
	
	// Dragging next page threshold
	@objc dynamic open var pageViewMinimumThresholdValue: CGFloat = 0.3
    
    public weak var pageViewController: UIPageViewController? {
        didSet {
			
			// Set page view delegate
			self.pageViewOriginalDelegate = self.pageViewController?.delegate
            self.pageViewController?.delegate = self
            
            // Find scroll view
            for subview in self.pageViewController?.view.subviews ?? [] {
                if let scrollView = subview as? UIScrollView {
					// Set scroll view delegate
					self.scrollViewOriginalDelegate = scrollView.delegate
                    scrollView.delegate = self
					
					// Keep scrollview
                    self.scrollView = scrollView
                    break
                }
            }
        }
    }
    
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

	@objc public func pageViewController(_ pageViewController: UIPageViewController,
								  willTransitionTo pendingViewControllers: [UIViewController]) {
		if self.pageViewOriginalDelegate?.responds(to: #selector(pageViewController(_:willTransitionTo:))) ?? false {
			self.pageViewOriginalDelegate?.pageViewController?(pageViewController,
															   willTransitionTo: pendingViewControllers)
		}
	}
	
	@objc public func pageViewController(_ pageViewController: UIPageViewController,
								  didFinishAnimating finished: Bool,
								  previousViewControllers: [UIViewController],
								  transitionCompleted completed: Bool) {
		if self.pageViewOriginalDelegate?.responds(to: #selector(pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:))) ?? false {
			self.pageViewOriginalDelegate?.pageViewController?(pageViewController,
															   didFinishAnimating: finished,
															   previousViewControllers: previousViewControllers,
															   transitionCompleted: completed)
		}
		
		// Call super method
		self.pageViewTransitionEnded(isCompleted: completed)
		self.isEndedPageViewTransition = true
	}
	
	@objc public func pageViewController(_ pageViewController: UIPageViewController,
								  spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
		if self.pageViewOriginalDelegate?.responds(to: #selector(pageViewController(_:spineLocationFor:))) ?? false {
			return (self.pageViewOriginalDelegate?.pageViewController?(pageViewController, spineLocationFor: orientation))!
		}
		
		return .none
	}
	
	@available(iOS 7.0, *)
	@objc public func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
		if self.pageViewOriginalDelegate?.responds(to: #selector(pageViewControllerSupportedInterfaceOrientations(_:))) ?? false {
			return (self.pageViewOriginalDelegate?.pageViewControllerSupportedInterfaceOrientations?(pageViewController))!
		}
		
		return UIInterfaceOrientationMask.portrait
	}
	
	@available(iOS 7.0, *)
	@objc public func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
		if self.pageViewOriginalDelegate?.responds(to: #selector(pageViewControllerPreferredInterfaceOrientationForPresentation(_:))) ?? false {
			return (self.pageViewOriginalDelegate?.pageViewControllerPreferredInterfaceOrientationForPresentation?(pageViewController))!
		}
		
		return UIInterfaceOrientation.portrait
	}
    
}

extension PuiPageViewSegmentedControl: UIScrollViewDelegate {
    
    @objc public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		if self.scrollViewOriginalDelegate?.responds(to: #selector(scrollViewWillBeginDragging(_:))) ?? false {
			self.scrollViewOriginalDelegate?.scrollViewWillBeginDragging?(scrollView)
		}
        
        // Set initial position
        if self.isEndedPageViewTransition {
            self.initialScrollViewPosition = scrollView.contentOffset.x
            self.isEndedPageViewTransition = false
        }
    }
    
    @objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if self.scrollViewOriginalDelegate?.responds(to: #selector(scrollViewDidScroll(_:))) ?? false {
			self.scrollViewOriginalDelegate?.scrollViewDidScroll?(scrollView)
		}
        
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
    
    @objc public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if self.scrollViewOriginalDelegate?.responds(to: #selector(scrollViewDidEndDecelerating(_:))) ?? false {
			self.scrollViewOriginalDelegate?.scrollViewDidEndDecelerating?(scrollView)
		}
    }
    
    @objc public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if self.scrollViewOriginalDelegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:))) ?? false {
			self.scrollViewOriginalDelegate?.scrollViewDidEndDragging?(scrollView,
																	   willDecelerate: decelerate)
		}
    }
    
    @objc public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if self.scrollViewOriginalDelegate?.responds(to: #selector(scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))) ?? false {
			self.scrollViewOriginalDelegate?.scrollViewWillEndDragging?(scrollView,
																		withVelocity: velocity,
																		targetContentOffset: targetContentOffset)
		}
        
        // Detect bounce effect and return
        if (self.selectedIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) ||
            self.selectedIndex == (self.items.count - 1) && scrollView.contentOffset.x >= scrollView.bounds.size.width {
            return
        }
        
        // Call end dragging method because configure view according to destionation index
        // If ratio more then 0.5, we will move to destination index. 0.5 means 50%
        if self.ratio != nil && (abs(self.ratio!) > 0.5 || abs(velocity.x) > self.pageViewMinimumThresholdValue ) {
            self.scrollViewEndDragging()
        }
        
    }
}
