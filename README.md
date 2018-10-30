# LSCustomNavigation

![](https://img.shields.io/cocoapods/v/LSCustomNavigation.svg?style=flat)
![](https://img.shields.io/cocoapods/p/LSCustomNavigation.svg?style=flat)

## A full custom navigation solution of Cocoa style for iOS apps.

### Basic use

Use `LSCustomNavigationController` as your navigation controller. Feel free to use it as the same as native `UINavigationController`.

To customize the navigation bar, your view controllers that embeded in the navigation system need to conform to `GY_CustomNavigationProtocol` protocol and offer a `LSNavigationItem` instance, whose property identifies the appearance of the navigation bar when current view controller is pushed into the navigation system, or popped to from the previous view controller. If the view controller don't conform to the `GY_CustomNavigationProtocol` protocol, a default one will be used.

```Objective-C
#pragma mark - GY_CustomNavigationProtocol

- (LSNavigationItem *)gy_customNavigationItem {
    LSNavigationItem *navigationItem = [[LSNavigationItem alloc] init];
    navigationItem.leftTitle = @"VCA";
    navigationItem.title = @"This is A";
    navigationItem.titleColor = [UIColor orangeColor];
    navigationItem.leftTitleColor = [UIColor orangeColor];
    UISwitch *UIswitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    navigationItem.customTitleView = UIswitch;
    navigationItem.barTranslucent = NO;
    navigationItem.barBackgroundColor = [UIColor cyanColor];
    return navigationItem;
}
```
