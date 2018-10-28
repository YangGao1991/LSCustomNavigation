//
//  GYNavigationAnimationGroup.h
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/18.
//  Copyright © 2018 高阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSNavigationAnimationGroup : NSObject

- (instancetype)initWithElements:(NSDictionary<NSString *, UIView *> *)elements;
- (void)addElement:(UIView *)element forKey:(NSString *)key;
- (__kindof UIView *)elementForKey:(NSString *)key;

@property (nonatomic, assign) BOOL active;

- (void)setAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
