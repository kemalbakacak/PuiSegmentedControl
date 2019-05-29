//
//  PuiPageViewSegmentedControl.swift
//  PuiSegmentedControl
//
//  Created by Kemal Bakacak on 20.01.2019.
//  Copyright © 2019 Kemal Bakacak. All rights reserved.
//

import UIKit

public protocol PuiPageViewSegmentedControlDelegate: NSObjectProtocol {
	
	func pageDidChanged(_ index: Int)
	func pageDidAppear(_ index: Int)
	
}

open class PuiPageViewSegmentedControl: UIView {
	
	// MARK: - Enums
	
	public enum ScrollDirection {
		case left
		case right
		case undefined
	}
	
	// MARK: - Delegates
	
	private weak var segmentedControlOriginalDelegate: PuiSegmentedControlDelegate?
	public weak var scrollViewDelegate: UIScrollViewDelegate?
	public weak var pageViewDelegate: PuiPageViewSegmentedControlDelegate?
	
	// MARK: - Public Properties
	
	public private(set) var currentIndex: Int!
	public private(set) var pages: [UIViewController]!
	public private(set) var nextViewSelectionThreshold: CGFloat!
	
	// MARK: - Private Properties
	
	private var containerView: UIScrollView!
	private var segmentedControl: PuiSegmentedControl?
	private var scrollDirection: ScrollDirection!
	private var beginContentOffset: CGFloat!
	private var lastContentOffset: CGFloat!
	private var didAppearIndexs: [Int] = []
	private var isAnimatingView: Bool = false
	
	// MARK: - Life Cycles
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.updateContainerView()
	}
	
	public func configure(pages: [UIViewController],
						  selectedIndex: Int = 0,
						  segmentedControl: PuiSegmentedControl? = nil,
						  nextViewSelectionThreshold: CGFloat? = 0.5) {
		self.currentIndex = selectedIndex
		self.pages = pages
		self.nextViewSelectionThreshold = nextViewSelectionThreshold
		
		// Keep segmentedcontrol
		self.segmentedControl = segmentedControl
		
		// Swap delegate
		self.segmentedControlOriginalDelegate = segmentedControl?.delegate
		segmentedControl?.delegate = self
		
		// Configure container view with scroll view
		self.containerView = UIScrollView()
		self.containerView.frame = CGRect(origin: .zero, size: self.bounds.size)
		self.containerView.bounces = true
		self.containerView.alwaysBounceHorizontal = true
		self.containerView.alwaysBounceVertical = false
		self.containerView.showsHorizontalScrollIndicator = false
		self.containerView.showsVerticalScrollIndicator = false
		self.containerView.isPagingEnabled = true
		self.containerView.delegate = self
		self.containerView.scrollsToTop = false
		self.addSubview(self.containerView)
		
		self.updateContainerView()
		
		// Add default view controller
		self.addViewController(at: self.currentIndex)
	}
	
	private func updateContainerView() {
		self.containerView.frame.size = self.bounds.size
		
		// Calculate content offset according to current index
		self.containerView.contentOffset = CGPoint(x: self.bounds.size.width * CGFloat(self.currentIndex), y: 0)
		
		// Calculate total content size according to page count
		self.containerView.contentSize = CGSize(width: self.bounds.size.width * CGFloat(self.pages.count),
												height: self.bounds.size.height)
		
		// Update pages size
		for index in 0..<self.pages.count where self.pages[index].view.superview != nil {
			self.pages[index].view.frame.size = self.bounds.size
			self.pages[index].view.frame.origin.x = self.getPosition(at: index)
		}
	}
	
	private func updateContent() {
		// Check bounce effect.
		if self.lastContentOffset <= 0 || self.lastContentOffset >= (self.containerView.contentSize.width - self.bounds.width) {
			return
		}
		
		if self.scrollDirection == nil || self.scrollDirection == .undefined {
			return
		}
		// Calculate current page index
		var pageIndex = Int(self.lastContentOffset / self.bounds.width)
		
		// Find destination index
		var destinationIndex: Int = pageIndex
		if self.scrollDirection == .right && pageIndex < (self.pages.count - 1) {
			destinationIndex = pageIndex + 1
		} else if pageIndex == self.pages.count {
			return
		}
		
		// Calculate ratio
		let differenceOffset = abs(self.lastContentOffset - (self.bounds.width * CGFloat(pageIndex)))
		var ratio = differenceOffset / self.bounds.width
		if self.scrollDirection == .left {
			pageIndex += 1
			ratio = 1 - ratio
		}
		self.segmentedControl?.scrollSegmentedControl(ratio: ratio,
													  nextViewSelectionThreshold: self.nextViewSelectionThreshold,
													  currentIndex: pageIndex,
													  destinationIndex: destinationIndex)
		
		// Add view controller
		self.addViewController(at: destinationIndex)
		
		// Call appear delegates
		if self.currentIndex != destinationIndex && !self.didAppearIndexs.contains(destinationIndex) {
			self.didAppearIndexs.append(destinationIndex)
			self.pageViewDelegate?.pageDidAppear(destinationIndex)
		}
	}
	
	private func addViewController(at index: Int) {
		let childViewController = self.pages[index]
		if childViewController.view.superview != nil {
			return
		}
		childViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		childViewController.view.frame.origin.x = self.getPosition(at: index)
		childViewController.view.frame.size = self.bounds.size
		self.containerView.addSubview(childViewController.view)
	}
	
	private func getPosition(at index: Int) -> CGFloat {
		return self.containerView.bounds.width * CGFloat(index)
	}
	
	private func getContentOffset(at index: Int) -> CGFloat {
		return self.containerView.bounds.width * CGFloat(index)
	}
	
	private func addViewController(from fromIndex: Int, to toIndex: Int) {
		for index in fromIndex..<(toIndex + 1) {
			self.addViewController(at: index)
		}
	}
}

extension PuiPageViewSegmentedControl: UIScrollViewDelegate {
	@objc public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
		self.lastContentOffset = scrollView.contentOffset.x
		self.beginContentOffset = scrollView.contentOffset.x
	}
	
	@objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
		if self.isAnimatingView {
			return
		}
		if self.beginContentOffset == nil || self.lastContentOffset == nil {
			return
		}
		if self.beginContentOffset > scrollView.contentOffset.x {
			self.scrollDirection = .left
		} else if self.beginContentOffset < scrollView.contentOffset.x {
			self.scrollDirection = .right
		} else {
			self.scrollDirection = .undefined
		}
		self.updateContent()
		self.lastContentOffset = scrollView.contentOffset.x
	}
	
	@objc public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		// Call delegate
		self.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
		
		// Get index
		let deceleratingIndex = Int(scrollView.contentOffset.x / self.bounds.width)
		
		// Call delegate if current page changed.
		if self.currentIndex != deceleratingIndex {
			self.pageViewDelegate?.pageDidChanged(deceleratingIndex)
			self.currentIndex = deceleratingIndex
		}
		
		// Remove all appeared indexs
		self.didAppearIndexs.removeAll()
		
		// Call segmented control method for configuration
		self.segmentedControl?.scrollViewDidEndDecelerating(at: deceleratingIndex)
	}
	
	@objc public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		self.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
	}
	
	@objc public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
												withVelocity velocity: CGPoint,
												targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		self.scrollViewDelegate?.scrollViewWillEndDragging?(scrollView,
															withVelocity: velocity,
															targetContentOffset: targetContentOffset)
	}
}

extension PuiPageViewSegmentedControl: PuiSegmentedControlDelegate {
	public func segmentedControlTransitionBegin(oldValue: Int, newValue: Int) {
		// Check original delegate method
		if self.segmentedControlOriginalDelegate?.responds(to: #selector(self.segmentedControlOriginalDelegate?.segmentedControlTransitionBegin(oldValue:newValue:))) ?? false {
			self.segmentedControlOriginalDelegate?.segmentedControlTransitionBegin(oldValue: oldValue, newValue: newValue)
		}
		
		// Add view controller between new and old values
		if oldValue > newValue {
			self.addViewController(from: newValue, to: oldValue)
		} else {
			self.addViewController(from: oldValue, to: newValue)
		}
		
		// Set content size
		self.containerView.setContentOffset(CGPoint(x: self.getContentOffset(at: newValue), y: self.containerView.contentOffset.y),
											animated: true)
		
		// Animation check
		self.isAnimatingView = true
		self.containerView.isUserInteractionEnabled = false
	}
	
	public func segmentedControlTransitionEnded(oldValue: Int, newValue: Int) {
		// Check original delegate method
		if self.segmentedControlOriginalDelegate?.responds(to: #selector(self.segmentedControlOriginalDelegate?.segmentedControlTransitionEnded(oldValue:newValue:))) ?? false {
			self.segmentedControlOriginalDelegate?.segmentedControlTransitionEnded(oldValue: oldValue, newValue: newValue)
		}
		
		// Animation check
		self.isAnimatingView = false
		self.containerView.isUserInteractionEnabled = true
	}
}
