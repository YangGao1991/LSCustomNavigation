//
//  GYNavigationDelegateProxy.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/26.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "LSNavigationDelegateProxy.h"
#import "LSCustomNavigationController.h"

static inline BOOL isHookedSelector(SEL selector) {
    return (selector == @selector(navigationController:didShowViewController:animated:) ||
            selector == @selector(navigationController:willShowViewController:animated:));
}

@interface LSNavigationDelegateProxy ()

@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property (nonatomic, weak) LSCustomNavigationController *customNavigationController;

@end

@implementation LSNavigationDelegateProxy

- (instancetype)initWithDelegate:(id<UINavigationControllerDelegate>)delegate
                          hooker:(LSCustomNavigationController *)navigationController {
    if (self) {
        self.delegate = delegate;
        self.customNavigationController = navigationController;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return isHookedSelector(aSelector) || [_delegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *first = [(NSObject *)_delegate methodSignatureForSelector:sel];
    NSMethodSignature *second = [(NSObject *)_customNavigationController methodSignatureForSelector:sel];
    if (first) {
        return first;
    }else if (second) {
        return second;
    }else {
        return nil;
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
//    [invocation setTarget:_delegate];
    SEL selector = [invocation selector];
    if ([_delegate respondsToSelector:selector]) {
        [invocation invokeWithTarget:_delegate];
    }
    if ([_customNavigationController respondsToSelector:selector]) {
        [invocation invokeWithTarget:_customNavigationController];
    }
}


@end
