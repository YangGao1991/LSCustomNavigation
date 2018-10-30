//
//  UIColor+LCTransition.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/24.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(LCTransition)

- (NSArray *)ls_componentsArray;

+ (UIColor *)ls_transitionColorFromColor:(UIColor *)originColor
                              toColor:(UIColor *)targetColor
                             progress:(CGFloat)progress;

- (CGFloat)ls_getAlphaValue;

@end

NS_ASSUME_NONNULL_END
