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
        self.leftNormalImage = [UIImage imageNamed:@"back_white"];
        self.leftHighligtedImage = [UIImage imageNamed:@"back_white"];
        self.leftTitleColor = [UIColor whiteColor];
        self.leftTitleFont = [UIFont systemFontOfSize:18];
        self.hideBackButton = NO;
        self.barTranslucent = YES;
        self.barTransparent = NO;
        self.titleColor = [UIColor whiteColor];
        self.titleFont = [UIFont systemFontOfSize:18];
        self.barHeight = kLSNavigationBarHeight;
        self.barHidden = NO;
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

@end
