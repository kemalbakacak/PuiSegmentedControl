//
//  PuiSegmentedControl.swift
//  PuiSegmentedControl
//
//  Created by Kemal Bakacak on 19.10.2018.
//  Copyright © 2018 Kemal Bakacak. All rights reserved.
//

import Foundation
import UIKit

public protocol PuiSegmentedControlDelegate: NSObjectProtocol {
    
    func segmentedControlTransationBegin(oldValue: Int, newValue: Int)
    func segmentedControlTransationEnded(oldValue: Int, newValue: Int)
    
}

open class PuiSegmentedControl: UIControl {
    
    // MARK: - Data Structures
    
    private struct SelectedView {
        var position: CGFloat!
        var width: CGFloat!
        
        init(position: CGFloat, width: CGFloat) {
            self.position = position
            self.width = width
        }
        
        func getMin() -> CGFloat {
            return self.position
        }
        
        func getMid() -> CGFloat {
            return self.position + (self.width / 2)
        }
        
        func getMax() -> CGFloat {
            return self.position + self.width
        }
        
        func isContain(value: CGFloat) -> Bool {
            return self.getMax() > value && self.getMin() < value
        }
    }
    
    // MARK: - Public Properties
    
    // The value of the animation tab when isAnimatedTabTransation property is true
    @objc dynamic open var animatedTabTransationDuration: TimeInterval = 1
    // The radius of the background.
    @objc dynamic open var backgroundCornerRadius: CGFloat = 0
    // The color of the background.
    @objc dynamic open var backgroundCustomColor: UIColor = .clear
    // The radius of the control's border.
    @objc dynamic open var borderCornerRadius: CGFloat = 0
    // The color of the control's border.
    @objc dynamic open var borderColor: UIColor = .clear
    // The size of the width control's border.
    @objc dynamic open var borderWidth: CGFloat = 2
    // The color of the background color.
    @objc dynamic open var unselectedViewBackgroundColor: UIColor = .white
    // The offset of the background from all around.
    @objc dynamic open var unselectedViewMargins: UIEdgeInsets = .zero
    // The attributes of the segment's title
    @objc dynamic open var unselectedTextAttributes: [NSAttributedString.Key: Any]?
    // The color of the selected view background color.
    @objc dynamic open var selectedViewBackgroundColor: UIColor = .purple
    // The offset of the selected view from all around.
    @objc dynamic open var selectedViewMargins: UIEdgeInsets = .zero
    // The attributes of the selected segment's title
    @objc dynamic open var selectedTextAttributes: [NSAttributedString.Key: Any] = [:]
    // The index of the selected segment's.
    @objc dynamic open var selectedIndex: Int = 0 {
        didSet {
            if self.isConfiguredView
                && !self.isDraggingSelectedView
                && oldValue != self.selectedIndex {
                self.changeSegment(oldValue: oldValue, newValue: self.selectedIndex)
            }
        }
    }
    // The color of the seperator's.
    @objc dynamic open var seperatorColor: UIColor = .purple
    // The radius of the seperator's.
    @objc dynamic open var seperatorCornerRadius: CGFloat = 2
    // The size of the width seperator's
    @objc dynamic open var seperatorWidth: CGFloat = 4
    // The offset of the seperator's from bottom.
    @objc dynamic open var seperatorMarginBottom: CGFloat = 0
    // The offset of the seperator's from top.
    @objc dynamic open var seperatorMarginTop: CGFloat = 0
    // If the property is true, tab transation will be animated.
    @objc dynamic open var isAnimatedTabTransation: Bool = false
    // If the property is true, selected segment's will be rounded.
    @objc dynamic open var isSelectViewAllCornerRadius: Bool = false
    // If the property is true, segments divided equals. Otherwise, segment's divided according to text length.
    @objc dynamic open var isEqualWidth: Bool = true
    // If the property is true, seperator will show.
    @objc dynamic open var isSeperatorActive: Bool = true
    // The titles of segments.
    open var items: [String] = [] {
        didSet {
            self.isConfiguredView = false
            self.setNeedsLayout()
        }
    }
    
    public var delegate: PuiSegmentedControlDelegate?
    
    // MARK: - Private Properties
    
    private var isConfiguredView: Bool = false
    private var selectedView: UIView = UIView()
    private var selectedViews: [SelectedView] = []
    private var labels: [PuiTitleLabel] = []
    private var seperatorViews: [UIView] = []
    
    // Panned
    private var isDraggingSelectedView: Bool = false
    private var isAnimatingSelectedView: Bool = false
    private var destinationIndex: Int = 0
    
    // MARK: - Init methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycles
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Check item count is zero
        if self.items.count == 0 {
            // Then do nothing
            return
        }
        
        // Configure segmented control
        if self.isConfiguredView {
            return
        } else {
            self.configure()
            self.isConfiguredView = true
        }
        
        // Update calculated width
        self.configureViewWidth()
        
        // Update label's and seperator's view frame
        for i in 0..<self.items.count {
            self.configureLabelFrame(index: i, label: self.labels[i])
            if self.isSeperatorActive && i != self.items.count - 1 {
                self.configureSeperatorFrame(index: i, seperatorView: self.seperatorViews[i])
            }
        }
        
        // Update segment's view frame
        self.changeSegment(oldValue: self.selectedIndex, newValue: self.selectedIndex)
    }
    
    // MARK: - Draw view methods
    
    private func configure() {
        // Remove all gesture recognizers
        for gestureRecognizer in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(gestureRecognizer)
        }
        
        // Remove all subviews
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        // Remove all element from required array
        self.labels.removeAll()
        self.selectedViews.removeAll()
        self.seperatorViews.removeAll()
        
        // Add gesture recognizer
        self.configureGestureRecognizer()
        
        // Call required layer methods
        self.configureBackgroundView()
        self.configureBorderView()
        self.configureUnselectedView()
        self.configureSelectedView()
        
        // Call required textlayer
        self.configureLabels()
        
        // Call seperator layer methods
        self.configureSeperatorViews()
    }
    
    private func configureBackgroundView() {
        self.layer.cornerRadius = self.backgroundCornerRadius
        self.backgroundColor = self.backgroundCustomColor
    }
    
    // Border View
    private func configureBorderView() {
        let borderView = UIView(frame: self.bounds)
        borderView.backgroundColor = self.borderColor
        borderView.layer.cornerRadius = self.borderCornerRadius
        borderView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(borderView)
    }
    
    // Background View
    private func configureUnselectedView() {
        let frame = CGRect(x: self.borderWidth,
                           y: self.borderWidth,
                           width: self.bounds.width - (2*self.borderWidth),
                           height: self.bounds.height - (2*self.borderWidth))
        let backgroundView = UIView(frame: self.applyMargin(rect: frame, to: self.unselectedViewMargins))
        backgroundView.backgroundColor = self.unselectedViewBackgroundColor
        backgroundView.layer.cornerRadius = self.borderCornerRadius - self.borderWidth
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(backgroundView)
    }
    
    // Selected View
    private func configureSelectedView() {
        self.configureViewWidth()
        
        // Configure init frame
        self.configureSelectedViewFrame()
        
        // Set autolayout proporty
        self.selectedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.selectedView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set background color
        self.selectedView.backgroundColor = self.selectedViewBackgroundColor
        
        // Set corner radius
        self.selectedView.layer.masksToBounds = true
        self.changeSelectedViewCornerRadius(index: self.selectedIndex)
        
        // Add sublayer
        self.addSubview(self.selectedView)
    }
    
    // Calculate segment's width according to public property.
    private func configureViewWidth() {
        // Remove all elements, because we add new values
        self.selectedViews = []
        
        // Get total segment count
        let totalSegmentCount = self.items.count
        
        if self.isEqualWidth {
            // Screen width divide by total segment count
            let availableWidth = self.bounds.width / CGFloat(totalSegmentCount)
            for i in 0..<totalSegmentCount {
                self.selectedViews.append(SelectedView(position: availableWidth * CGFloat(i),
                                                       width: availableWidth))
            }
        } else {
            // Calculate each segment width according to text sizes.
            // Firstly, get total length
            var totalSize = 0
            for item in items {
                totalSize += item.count
            }
            // Then, append position and width
            let width = self.bounds.width
            var currentTotalSize = 0
            for i in 0..<totalSegmentCount {
                let itemSize = items[i].count
                // Calculate start x position
                let itemPosition = width * CGFloat(Float(currentTotalSize) / Float(totalSize))
                // Calculate width
                let itemWidth = width * CGFloat((Float(itemSize) / Float(totalSize)))
                // Append array
                self.selectedViews.append(SelectedView(position: itemPosition, width: itemWidth))
                // Add current item size
                currentTotalSize += itemSize
            }
        }
    }
    
    // Text Layers
    private func configureLabels() {
        for i in 0..<self.items.count {
            let label = PuiTitleLabel(text: items[i],
                                      selectedAttribute: self.selectedTextAttributes,
                                      unselectedAttribute: self.unselectedTextAttributes)
            
            // Configure frame
            self.configureLabelFrame(index: i, label: label)
            
            // Append array
            self.labels.append(label)
            
            // Add sublayer
            self.addSubview(label)
        }
    }
    
    // Calculate label frame's according to text states
    private func configureLabelFrame(index: Int, label: PuiTitleLabel) {
        label.isSelected = (index == self.selectedIndex)
        
        // Set frame
        label.frame = CGRect(x: self.selectedViews[index].position,
                             y: 0,
                             width: self.selectedViews[index].width,
                             height: self.bounds.height)
    }
    
    // Seperator Views
    private func configureSeperatorViews() {
        // Check status
        if !isSeperatorActive {
            return
        }
        
        for i in 0..<self.items.count - 1 {
            let seperatorView = UIView()
            
            // Configure frame
            self.configureSeperatorFrame(index: i, seperatorView: seperatorView)
            
            // Set background color
            seperatorView.backgroundColor = self.seperatorColor
            
            // Set corner radius
            seperatorView.layer.masksToBounds = true
            seperatorView.layer.cornerRadius = self.seperatorCornerRadius
            
            // Append array
            self.seperatorViews.append(seperatorView)
            
            // Add sublayer
            self.addSubview(seperatorView)
        }
    }
    
    // Calculate seperator frame's
    private func configureSeperatorFrame(index: Int, seperatorView: UIView) {
        // Set frame
        seperatorView.frame = CGRect(x: self.labels[index].frame.maxX - (self.seperatorWidth/2),
                                     y: self.seperatorMarginTop,
                                     width: self.seperatorWidth,
                                     height: self.bounds.height - seperatorMarginTop - seperatorMarginBottom)
    }
    
    // MARK: - Changed Segment Actions.
    
    // Set radius of the segment's according to index and positions.
    private func changeSelectedViewCornerRadius(index: Int) {
        // Set zero
        self.selectedView.layer.cornerRadius = 0
        
        // Calculate difference
        let calculatedCornerRadius = self.borderCornerRadius -
            (self.borderWidth + ((self.selectedViewMargins.top + self.selectedViewMargins.bottom) / 2))
        
        // Check required status.
        if self.isSelectViewAllCornerRadius {
            self.selectedView.layer.cornerRadius = calculatedCornerRadius
        } else {
            self.selectedView.layer.mask = nil
            // Check first and last segment position for corners radius.
            if index == 0 {
                self.roundCorners(corners: [.topLeft, .bottomLeft], radius: calculatedCornerRadius)
            } else if index == (self.items.count - 1) {
                self.roundCorners(corners: [.topRight, .bottomRight], radius: calculatedCornerRadius)
            }
        }
    }
    
    // Configure segment view's according to old and new value.
    private func changeSegment(oldValue: Int, newValue: Int) {
        self.selectedIndex = newValue
        
        // Setup selectedView
        self.configureSelectedViewFrame()
        
        // Setup corners
        self.changeSelectedViewCornerRadius(index: self.selectedIndex)
        
        // Change attributes
        self.labels[oldValue].isSelected = false
        self.labels[newValue].isSelected = true
        
        self.changeSeperatorVisibility()
        
        // Set animated
        self.isDraggingSelectedView = false
        self.isAnimatingSelectedView = false
        
        // Call end transaction method
        self.segmentedControlTransationEnded(oldValue: oldValue, newValue: newValue)
        
        // Send action
        self.sendActions(for: .valueChanged)
    }
    
    private func viewTappedSegmentChange(oldValue: Int, newValue: Int) {
        // Check animation
        if self.isDraggingSelectedView {
            return
        }
        
        // Set animated
        self.isDraggingSelectedView = true
        
        // Call begin transaction method
        self.segmentedControlTransationBegin(oldValue: oldValue, newValue: newValue)
        
        // Check is animated tab transation
        if self.isAnimatedTabTransation {
            UIView.animate(withDuration: self.animatedTabTransationDuration,
                           animations: { [weak self] in
                            guard let self = self else { return }
                            self.isAnimatingSelectedView = true
                            
                            // Update frame position
                            self.selectedView.frame.origin.x = self.selectedViews[newValue].position
                            
                            // If not equal all width, set new width
                            if !self.isEqualWidth {
                                self.selectedView.frame.size.width = self.selectedViews[newValue].width
                            }
            }) { [weak self] finished in
                guard let self = self else { return }
                if finished {
                    self.viewTappedSegmentChangeEnded(oldValue: oldValue, newValue: newValue)
                }
            }
        } else {
            self.isAnimatingSelectedView = true
            self.viewTappedSegmentChangeEnded(oldValue: oldValue, newValue: newValue)
        }
    }
    
    private func viewTappedSegmentChangeEnded(oldValue: Int, newValue: Int) {
        // Change segment normally
        self.changeSegment(oldValue: oldValue, newValue: newValue)
        
        // Remove animation
        self.selectedView.layer.removeAllAnimations()
    }
    
    // Configure selected view frame according to global
    private func configureSelectedViewFrame() {
        let frame = CGRect(x: self.selectedViews[self.selectedIndex].position,
                           y: 0,
                           width: self.selectedViews[self.selectedIndex].width,
                           height: self.bounds.height)
        self.selectedView.frame = self.applyMargin(rect: frame, to: self.selectedViewMargins)
        
        // Remove animation
        self.selectedView.layer.removeAllAnimations()
    }
    
    // Configure seperator visibility according to selected index
    private func changeSeperatorVisibility() {
        // Check status for seperator
        if !self.isSeperatorActive {
            return
        }
        
        // Set visibility for seperators
        self.seperatorViews.forEach { (seperator) in
            seperator.isHidden = false
        }
        if self.selectedIndex == 0 {
            self.seperatorViews[0].isHidden = true
        } else if self.selectedIndex == self.items.count - 1 {
            self.seperatorViews[self.seperatorViews.count - 1].isHidden = true
        } else {
            self.seperatorViews[self.selectedIndex - 1].isHidden = true
            self.seperatorViews[self.selectedIndex].isHidden = true
        }
    }
    
    // MARK: - Touch Tracking
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewTapped(sender: UITapGestureRecognizer?) {
        if let sender = sender {
            let touchPoint = sender.location(in: self)
            for i in 0..<labels.count {
                // Create new size because we need to click all view. We changed textLayer height values.
                let size: CGRect = CGRect(x: labels[i].frame.minX,
                                          y: 0,
                                          width: labels[i].frame.width,
                                          height: self.bounds.height)
                if size.contains(touchPoint) {
                    self.viewTappedSegmentChange(oldValue: self.selectedIndex, newValue: i)
                    break
                }
            }
        }
    }
    
    // MARK: - Helper methods
    
    // Set radius of the specific corner's.
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.selectedView.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.selectedView.layer.mask = mask
    }
    
    // Margin according to rect position
    private func applyMargin(rect: CGRect, to: UIEdgeInsets) -> CGRect {
        return CGRect(x: rect.minX + to.left,
                      y: rect.minY + to.top,
                      width: rect.width - to.left - to.right,
                      height: rect.height - to.bottom - to.top)
    }
    
    // MARK: - Helper Methods for Page View
    
    // When scrolling pageview, we need to upload segmented control with private function in this class
    public func scrollSegmentedControl(ratio: CGFloat) {
        if self.isAnimatingSelectedView {
            return
        }
        
        // For Layoutsubviews control
        self.isDraggingSelectedView = true
        
        // Get direction
        let isMovingToRight = ratio < 0
        
        // Check out of view
        if (isMovingToRight && self.selectedIndex == (self.selectedViews.count - 1))
            || (!isMovingToRight && self.selectedIndex == 0) {
            // When dragging out of view, then we can set dragging property to false
            self.isDraggingSelectedView = false
            return
        }
        
        // Get following index
        self.destinationIndex = isMovingToRight ? (self.selectedIndex + 1) : (self.selectedIndex - 1)
        
        // Get current view
        let currentView = self.selectedViews[self.selectedIndex]
        
        // If all view is not equal then calculate added width
        if !self.isEqualWidth {
            // Get destination view
            let destinationView = self.selectedViews[self.destinationIndex]
            
            // Configure width
            let addedWidth = abs(destinationView.width - currentView.width) * abs(ratio)
            if destinationView.width > currentView.width {
                self.selectedView.frame.size.width = currentView.width + addedWidth
            } else {
                self.selectedView.frame.size.width = currentView.width - addedWidth
            }
            
            // Configure position
            if isMovingToRight {
                self.selectedView.frame.origin.x = currentView.position + (currentView.width * abs(ratio))
            } else {
                self.selectedView.frame.origin.x = currentView.position - (destinationView.width * abs(ratio))
            }
            
        } else {
            // Calculate new position
            let newPosition = currentView.position - (currentView.width * ratio)
            self.selectedView.frame.origin.x = newPosition
        }
    }
    
    // When page view delegate triggered, this function configure to segmented control.
    public func pageViewTransactionEnded(isCompleted: Bool) {
        if isCompleted {
            self.changeSegment(oldValue: self.selectedIndex, newValue: self.destinationIndex)
        } else {
            self.isDraggingSelectedView = false
        }
    }
    
    // Call function, if subclass is page view segmented control.
    // Then, developer configured view when transaction beginned.
    open func segmentedControlTransationBegin(oldValue: Int, newValue: Int) {
        self.delegate?.segmentedControlTransationBegin(oldValue: oldValue, newValue: newValue)
    }
    
    // Call deelgate function, if subclass is page view segmented control.
    // Then, developer configured view when transaction ended.
    open func segmentedControlTransationEnded(oldValue: Int, newValue: Int) {
        self.delegate?.segmentedControlTransationEnded(oldValue: oldValue, newValue: newValue)
    }
}

