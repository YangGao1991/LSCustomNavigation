# LSCustomNavigation

![](https://img.shields.io/cocoapods/v/LSCustomNavigation.svg?style=flat)
![](https://img.shields.io/cocoapods/p/LSCustomNavigation.svg?style=flat)

### What is it for

The native navigation system of Cocoa, say, `UINavigationController`, `UINavigationBar` and `UINavigationItem` is somewhat difficult to be customized, e.g., to set different height in some particular scenes. **LSCustomNavigation** is just here aiming to make things easier, while the Cocoa transition style is still remained. More custom transition styles will be available in the future.

### Basic usage

Use `LSCustomNavigationController` as your navigation controller. Feel free to use it just the same way as native `UINavigationController`.

To customize the navigation bar, your view controllers that embeded in the navigation system need to conform to `LSCustomNavigationProtocol` protocol and offer a `LSNavigationItem` instance, whose properties identity the appearance of the navigation bar when current view controller is pushed into the navigation system, or popped to from the previous view controller. If the view controller don't conform to the `LSCustomNavigationProtocol` protocol, a default one will be used. 

```Objective-C
#pragma mark - LSCustomNavigationProtocol

- (LSNavigationItem *)ls_customNavigationItem {
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

You can also modify properties of `[LSNavigationItem appearance]` to config global navigation bar appearance:

```Objective-C
[LSNavigationItem appearance].barBackgroundColor = [UIColor lightGrayColor];
```

### System requirement

- iOS 8.0 +
