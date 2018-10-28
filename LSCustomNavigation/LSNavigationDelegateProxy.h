//
//  GYNavigationDelegateProxy.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/26.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LSCustomNavigationController;
@protocol UINavigationControllerDelegate;

@interface LSNavigationDelegateProxy : NSProxy

- (instancetype)initWithDelegate:(id<UINavigationControllerDelegate>)delegate
                          hooker:(LSCustomNavigationController *)navigationController;
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
