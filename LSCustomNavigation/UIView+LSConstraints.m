//
//  UIView+LSConstraints.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/22.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "UIView+LSConstraints.h"
#import <objc/runtime.h>

static char verticalConstraintKey;
static char horizonConstraintKey;

@implementation UIView(LSConstraints)

- (void)setLs_verticalConstraint:(NSLayoutConstraint *)verticalConstraint {
    objc_setAssociatedObject(self, &verticalConstraintKey, verticalConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)ls_verticalConstraint {
    return objc_getAssociatedObject(self, &verticalConstraintKey);
}

- (void)setLs_horizonConstraint:(NSLayoutConstraint *)horizonConstraint {
    objc_setAssociatedObject(self, &horizonConstraintKey, horizonConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)ls_horizonConstraint {
    return objc_getAssociatedObject(self, &horizonConstraintKey);
}


@end
