//
//  GYNavigationAnimationGroup.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/18.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "LSNavigationAnimationGroup.h"

@interface LSNavigationAnimationGroup ()

@property (nonatomic, strong) NSMutableDictionary *elements;

@end

@implementation LSNavigationAnimationGroup

- (instancetype)init {
    if (self = [super init]) {
        self.elements = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithElements:(NSDictionary<NSString *, UIView *> *)elements {
    if (self = [super init]) {
        self.elements = [elements mutableCopy];
    }
    return self;
}

- (void)addElement:(UIView *)element forKey:(nonnull NSString *)key {
    if (element && key) {
        [self.elements setObject:element forKey:key];
    }
}

- (__kindof UIView *)elementForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [self.elements objectForKey:key];
}

- (void)setAlpha:(CGFloat)alpha {
    for (UIView *anElement in self.elements.allValues) {
        anElement.alpha = alpha;
    }
}
@end
