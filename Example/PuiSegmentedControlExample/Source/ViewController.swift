//
//  ViewController.swift
//  PuiSegmentedControlExample
//
//  Created by Kemal Bakacak on 19.10.2018.
//  Copyright © 2018 Kemal Bakacak. All rights reserved.
//

import UIKit
import PuiSegmentedControl

class ViewController: UIViewController {

    @IBOutlet weak var puiSegmentedControl1: PuiSegmentedControl!
    @IBOutlet weak var puiSegmentedControl2: PuiSegmentedControl!
    @IBOutlet weak var puiSegmentedControl3: PuiSegmentedControl!
    @IBOutlet weak var puiSegmentedControl4: PuiSegmentedControl!
    @IBOutlet weak var puiSegmentedControl5: PuiSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var unselectedTextAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 15),
            .foregroundColor : UIColor.darkGray
        ]
        var selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 15),
            .foregroundColor : UIColor.white
        ]
        
        // Configure 1
        puiSegmentedControl1.selectedTextAttributes = selectedTextAttributes
        puiSegmentedControl1.unselectedTextAttributes = unselectedTextAttributes
        puiSegmentedControl1.backgroundCustomColor = UIColor.gray
        puiSegmentedControl1.backgroundCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl1.borderCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl1.seperatorMarginTop = 3
        puiSegmentedControl1.seperatorMarginBottom = 3
        puiSegmentedControl1.items = ["Tab 1", "Tab2 Tab2 Tab2 Tab2 Tab2", "Tab3"]
        
        // Configure 2
        puiSegmentedControl2.selectedTextAttributes = selectedTextAttributes
        puiSegmentedControl2.unselectedTextAttributes = unselectedTextAttributes
        puiSegmentedControl2.backgroundCustomColor = UIColor.gray
        puiSegmentedControl2.backgroundCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl2.borderCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl2.seperatorMarginTop = 3
        puiSegmentedControl2.seperatorMarginBottom = 3
        puiSegmentedControl2.isEqualWidth = false
        puiSegmentedControl2.items = ["123 123", "123 123 123", "123"]
        
        // Configure 3
        selectedTextAttributes[.foregroundColor] = UIColor.purple
        unselectedTextAttributes[.foregroundColor] = UIColor.white
        puiSegmentedControl3.selectedTextAttributes = selectedTextAttributes
        puiSegmentedControl3.unselectedTextAttributes = unselectedTextAttributes
        puiSegmentedControl3.unselectedViewBackgroundColor = UIColor.lightGray
        puiSegmentedControl3.selectedViewBackgroundColor = UIColor.clear
        puiSegmentedControl3.borderCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl3.isSeperatorActive = false
        puiSegmentedControl3.items = ["Tab 1", "Tab2 Tab2 Tab2 Tab2 Tab2", "Tab3"]
        
        // Configure 4
        unselectedTextAttributes[.foregroundColor] = UIColor.darkGray
        puiSegmentedControl4.selectedTextAttributes = selectedTextAttributes
        puiSegmentedControl4.unselectedTextAttributes = unselectedTextAttributes
        puiSegmentedControl4.unselectedViewBackgroundColor = UIColor.lightGray
        puiSegmentedControl4.selectedViewBackgroundColor = UIColor.blue
        puiSegmentedControl4.borderWidth = 0
        puiSegmentedControl4.selectedViewMargins = UIEdgeInsets(top: 40, left: 5, bottom: 0, right: 5)
        puiSegmentedControl4.unselectedViewMargins = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        puiSegmentedControl4.isSeperatorActive = false
        puiSegmentedControl4.items = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
        
        // Configure 5
        selectedTextAttributes[.foregroundColor] = UIColor.white
        unselectedTextAttributes[.foregroundColor] = UIColor.darkGray
        puiSegmentedControl5.selectedTextAttributes = selectedTextAttributes
        puiSegmentedControl5.unselectedTextAttributes = unselectedTextAttributes
        puiSegmentedControl5.backgroundCustomColor = UIColor.gray
        puiSegmentedControl5.backgroundCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl5.borderCornerRadius = puiSegmentedControl1.frame.height / 2
        puiSegmentedControl5.seperatorMarginTop = 3
        puiSegmentedControl5.seperatorMarginBottom = 3
        puiSegmentedControl5.isSelectViewAllCornerRadius = true
        puiSegmentedControl5.items = ["Tab 1", "Tab2"]
    }


    @IBAction func segmentedControlValueChanged(_ sender: PuiSegmentedControl) {
        print(sender.selectedIndex)
    }
}

