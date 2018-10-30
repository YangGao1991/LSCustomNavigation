//
//  UIView+LSConstraints.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/22.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(LSConstraints)

@property (nonatomic, strong) NSLayoutConstraint *ls_verticalConstraint;
@property (nonatomic, strong) NSLayoutConstraint *ls_horizonConstraint;

@end

NS_ASSUME_NONNULL_END
