PuiSegmentedControl is a customizable for segmented control.

## Features
- More configuration according to UISegmentedControl
- Configure title styling with NSAttributedString.Key such as font, color etc.
- Styling border, background, seperator etc.
- Animated segment change (Not working with different corner radius).
- Supported scroll when scrolling UIPageViewController (Same as above matter).
- Written with Swift :)

## Installation
### Cocoapods
The easiest way of installing PuiSegmentedControl is via CocoaPods.

```bash
pod 'PuiSegmentedControl'
```

### Carthage
To integrate PuiSegmentedControl into your Xcode project using Carthage, specify it in your `Cartfile`:

```bash
github "kbakacak/PuiSegmentedControl" ~> 1.1.0
```

Run `carthage update` to build the framework and drag the built `PuiSegmentedControl.framework` into your Xcode project.

## Usage
- Add view to your storyboard and set class PuiSegmentedControl.
- Create outlets and import PuiSegmentedControl to your view controller.
- Finally, set properties according to your design before set titles.
- You can check screenshots demos under the "Example" folder.

Variables that you can use:

```swift
open var animatedTabTransationDuration: TimeInterval = 1 // The value of the animation tab when isAnimatedTabTransation property is true
open var backgroundCornerRadius: CGFloat = 0 // The radius of the background.
open var backgroundCustomColor: UIColor = .clear // The color of the background.
open var borderCornerRadius: CGFloat = 0 // The radius of the control's border.
open var borderColor: UIColor = .clear // The color of the control's border.
open var borderWidth: CGFloat = 2 // The size of the width control's border.
open var unselectedViewBackgroundColor: UIColor = .white // The color of the background color.
open var unselectedViewMargins: UIEdgeInsets = .zero // The offset of the background from all around.
open var unselectedTextAttributes: [NSAttributedString.Key: Any]? // The attributes of the segment's title
open var selectedViewBackgroundColor: UIColor = .purple // The color of the selected view background color.
open var selectedViewMargins: UIEdgeInsets = .zero // The offset of the selected view from all around.
open var selectedTextAttributes: [NSAttributedString.Key: Any] = [:] // The attributes of the selected segment's title
open var selectedIndex: Int = 0 // The index of the selected segment's.
open var seperatorColor: UIColor = .purple // The color of the seperator's.
open var seperatorCornerRadius: CGFloat = 2 // The radius of the seperator's.
open var seperatorWidth: CGFloat = 4 // The size of the width seperator's
open var seperatorMarginBottom: CGFloat = 0 // The offset of the seperator's from bottom.
open var seperatorMarginTop: CGFloat = 0 // The offset of the seperator's from top.
open var isAnimatedTabTransation: Bool = false // If the property is true, tab transation will be animated.
open var isSelectViewAllCornerRadius: Bool = false // If the property is true, selected segment's will be rounded.
open var isEqualWidth: Bool = true // If the property is true, segments divided equals. Otherwise, segment's divided according to text length.
open var isSeperatorActive: Bool = true // If the property is true, seperator will show.
open var items: [String] = [] // The titles of segments.
```

### Usage with UIPageViewController

If you want to use with UIPageViewController, you need to use ``PuiPageViewSegmentedControl`` and set ``pageViewController`` property for required delegate. You can example ``PageViewController`` in example project. ``PuiPageViewSegmentedControl``is subclass of ``PuiSegmentedControl`` so you can use same properties above.

![Screenshot](https://github.com/kbakacak/PuiSegmentedControl/blob/develop/DemoScreenshot.png)

## License
PuiSegmentedControl is released under the MIT license. [See LICENSE](https://github.com/kbakacak/PuiSegmentedControl/blob/master/LICENSE) for details.
