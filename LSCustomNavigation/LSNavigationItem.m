//
//  GYNavigationItem.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "LSNavigationItem.h"
#import "LSNavigationBar.h"

@interface LSNavigationItem ()

//@property (nonatomic,strong,readwrite) UIImage  * leftNormalImage;
//@property (nonatomic,strong,readwrite) UIImage  * leftHighligtedImage;
//@property (nonatomic,strong,readwrite) NSString * leftTitle;
//@property (nonatomic,strong,readwrite) UIColor  * leftTitleColor;

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

+ (instancetype)defaultNavigationItem {
    LSNavigationItem *defaultItem = [[LSNavigationItem alloc] init];
    return defaultItem;
}

//- (void)setLeftButtonWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
//    self.leftNormalImage = normal;
//    self.leftHighligtedImage = highlighted;
//    self.leftTitle = title;
//    self.leftTitleColor = titleColor;
//}
//
//- (void)setLeftButtonWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted {
//    [self setLeftButtonWithNormalImage:normal highlightedImage:highlighted title:nil titleColor:nil];
//}
//- (void)setLeftButtonWithImage:(UIImage *)image {
//    [self setLeftButtonWithNormalImage:image highlightedImage:nil title:nil titleColor:nil];
//}
//- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
//    [self setLeftButtonWithNormalImage:nil highlightedImage:nil title:title titleColor:titleColor];
//}


@end
