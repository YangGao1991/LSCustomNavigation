//
//  LSNavigationItem.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSNavigationItem : NSObject

// Title View
/*
 * @brief 设置默认的Title View
 *
 */
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

// 会覆盖默认title view
@property (nonatomic, strong) UIView *customTitleView;

// 默认button，不调用自定义的返回函数，在这里修改
/*
 * @brief 设置默认的 backbutton 的图片或者文字
 *
 */
@property (nonatomic, assign, getter=isBackButtonHidden) BOOL hideBackButton;
@property (nonatomic, strong) UIImage * leftNormalImage;
@property (nonatomic, strong) UIImage * leftHighligtedImage;
@property (nonatomic, strong) NSString * leftTitle;
@property (nonatomic, strong) UIColor  * leftTitleColor;
@property (nonatomic, strong) UIFont *leftTitleFont;


// customizing Views,不做任何处理和约束，也不会调用自定义的返回，可以由外面直接传入
@property (nonatomic, strong) UIView * leftView;

@property (nonatomic, strong) UIView *customRightView;

// bar appearance
// bar.backgroundColor，不影响 bar 中的元素
@property (nonatomic, strong) UIColor * barBackgroundColor;
// bar.backgroundColor.alpha = 0
@property (nonatomic, assign, getter=isBarTransparent) BOOL barTransparent;
 // bar.backgroundColor.alpha = 0.7
@property (nonatomic, assign, getter=isTranslucent) BOOL barTranslucent;
@property (nonatomic, strong) UIImage * barBackgroundImage;
@property (nonatomic, assign, getter=isBarHidden) BOOL barHidden;

@property (nonatomic, assign) CGFloat barHeight;

// 重定义返回按钮动作
typedef void(^LSButtonAction)(id sender);
@property (nonatomic, copy) LSButtonAction customLeftButtonAction;

+ (instancetype)appearance;
+ (instancetype)appearanceCopy;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
