//
//  UIColor+LCTransition.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/24.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "UIColor+LCTransition.h"

@implementation UIColor(LCTransition)

- (NSArray *)ls_componentsArray {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = components[3];
    return @[@(r), @(g), @(b), @(a)];
}

+ (UIColor *)ls_transitionColorFromColor:(UIColor *)originColor
                              toColor:(UIColor *)targetColor
                             progress:(CGFloat)progress {
    NSArray *originComponents = [originColor ls_componentsArray];
    NSArray *targetComponents = [targetColor ls_componentsArray];
    NSArray *distanceComponent = @[@([targetComponents[0] doubleValue] - [originComponents[0] doubleValue]),
                                   @([targetComponents[1] doubleValue] - [originComponents[1] doubleValue]),
                                   @([targetComponents[2] doubleValue] - [originComponents[2] doubleValue]),
                                   @([targetComponents[3] doubleValue] - [originComponents[3] doubleValue])];
    CGFloat r = [originComponents[0] doubleValue] + [distanceComponent[0] doubleValue] * progress;
    CGFloat g = [originComponents[1] doubleValue] + [distanceComponent[1] doubleValue] * progress;
    CGFloat b = [originComponents[2] doubleValue] + [distanceComponent[2] doubleValue] * progress;
    CGFloat a = [originComponents[3] doubleValue] + [distanceComponent[3] doubleValue] * progress;
//    NSLog(@"r=%f, g=%f, b=%f, a=%f",r,g,b,a);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (CGFloat)ls_getAlphaValue {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    return components[3];
}
@end
