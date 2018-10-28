//
//  CustomNavigationController.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSNavigationItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GY_CustomNavigationProtocol <NSObject>

@property (nonatomic, strong, readonly) LSNavigationItem *gy_customNavigationItem;

@end

@interface LSCustomNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
