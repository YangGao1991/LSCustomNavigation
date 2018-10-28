//
//  GYNavigationBar.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSNavigationItem.h"

NS_ASSUME_NONNULL_BEGIN

#define kLSNavigationBarHeight 80
#define kLSStatusBarHeight 20

@protocol GYNavigationBarDelegate <NSObject>

- (void)didClickedBackButton;

@end

typedef NS_ENUM(NSUInteger, GYNavigationTransitionType) {
    GYNavigationTransitionType_Push,
    GYNavigationTransitionType_Pop,
    GYNavigationTransitionType_InteractivePop,
};

@interface LSNavigationBar : UIView

@property(nonatomic, readonly, strong) LSNavigationItem *topItem;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, weak) id<GYNavigationBarDelegate> delegate;

// 操作 navigation item
- (void)pushNavigationItem:(LSNavigationItem *)item animated:(BOOL)animated;
- (LSNavigationItem *)popNavigationItemAnimated:(BOOL)animated;

- (void)updateContentBeforeAnimationWithTransitionType:(GYNavigationTransitionType)transitionType;
- (void)updateContentAnimationProgress:(CGFloat)progress;
// 侧滑返回被取消
- (void)cancelContentAnimation;
//- (void)contentAnimationDidComplete;

@end

NS_ASSUME_NONNULL_END
