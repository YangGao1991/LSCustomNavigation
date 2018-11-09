//
//  GYNavigationItem.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "LSNavigationItem.h"
#import "LSNavigationBar.h"

static LSNavigationItem *defaultNavigationItem = nil;

@interface LSNavigationItem ()

@end

@implementation LSNavigationItem

- (instancetype)init {
    if (self = [super init]) {
        self.barBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.leftTitleColor = [UIColor whiteColor];
        self.leftTitleFont = [UIFont systemFontOfSize:18];
        self.hideBackButton = NO;
        self.barTranslucent = YES;
        self.barTransparent = NO;
        self.titleColor = [UIColor whiteColor];
        self.titleFont = [UIFont systemFontOfSize:18];
        self.barHeight = kLSNavigationBarHeight;
        self.barHidden = NO;
        self.isStatusBarHidden = NO;
    }
    return self;
}

+ (instancetype)appearance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultNavigationItem = [[LSNavigationItem alloc] init];
    });
    return defaultNavigationItem;
}

+ (instancetype)appearanceCopy {
    LSNavigationItem *newItem = [self itemCopiedFromItem:defaultNavigationItem];
    return newItem;
}

+ (LSNavigationItem *)itemCopiedFromItem:(LSNavigationItem *)item {
    LSNavigationItem *newItem = [[LSNavigationItem alloc] init];
    newItem.title = item.title;
    newItem.titleColor = item.titleColor;
    newItem.titleFont = item.titleFont;
    newItem.customTitleView = item.customTitleView;
    newItem.hideBackButton = item.hideBackButton;
    newItem.leftNormalImage = item.leftNormalImage;
    newItem.leftHighligtedImage = item.leftHighligtedImage;
    newItem.leftTitle = item.leftTitle;
    newItem.leftTitleColor = item.leftTitleColor;
    newItem.leftTitleFont = item.leftTitleFont;
    newItem.customLeftView = item.customLeftView;
    newItem.customRightView = item.customRightView;
    newItem.barBackgroundColor = item.barBackgroundColor;
    newItem.barTransparent = item.barTransparent;
    newItem.barTranslucent = item.barTranslucent;
    newItem.barBackgroundImage = item.barBackgroundImage;
    newItem.barHidden = item.barHidden;
    newItem.barHeight = item.barHeight;
    newItem.isStatusBarHidden = item.isStatusBarHidden;
    return newItem;
}

@end
