//
//  CustomNavigationController.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "LSCustomNavigationController.h"
#import "LSNavigationBar.h"
#import "LSNavigationDelegateProxy.h"

#define LS_SCREEN_SIZE  ([UIScreen mainScreen].bounds.size)

@interface LSCustomNavigationController ()
<UINavigationControllerDelegate,
GYNavigationBarDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, strong) LSNavigationBar *bar;
@property (nonatomic, strong) LSNavigationDelegateProxy *delegateProxy;

@end

@implementation LSCustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
    if (!self.delegate) {
        self.delegate = self;
    }
    UIGestureRecognizer *popGesture = self.interactivePopGestureRecognizer;
    [popGesture addTarget:self action:@selector(handlePopgesture:)];
    [self.view addSubview:self.bar];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (delegate == self || !delegate) {
        _delegateProxy = nil;
        super.delegate = self;
    }else {
        _delegateProxy = [[LSNavigationDelegateProxy alloc] initWithDelegate:delegate
                                                                      hooker:self];
        super.delegate = (id<UINavigationControllerDelegate>)_delegateProxy;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if ([viewController conformsToProtocol:@protocol(LSCustomNavigationProtocol)]
        && [viewController respondsToSelector:@selector(ls_customNavigationItem)]) {
        UIViewController<LSCustomNavigationProtocol> *toViewController = (UIViewController<LSCustomNavigationProtocol> *)viewController;
        LSNavigationItem *toItem = [toViewController ls_customNavigationItem];
        if (!toItem) {
            toItem = [LSNavigationItem appearance];
        }
        [self.bar pushNavigationItem:toItem animated:animated];
    }else {
        LSNavigationItem *toItem = [LSNavigationItem appearance];
        if (viewController.title && viewController.title.length > 0) {
            toItem.title = viewController.title;
        }
        [self.bar pushNavigationItem:toItem animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        [self.bar popNavigationItemAnimated:YES];
    }
    return [super popViewControllerAnimated:animated];
}

#pragma mark - GYNavigationBarDelegate

- (void)didClickedBackButton {
    [self popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    id<UIViewControllerTransitionCoordinator> coor = self.transitionCoordinator;
    if (coor != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
            [self dealInteractionChanges:context];
#pragma clang diagnostic pop
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}


- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    // 侧滑手势结束，由系统接管
    if ([context isCancelled]) {// 自动取消了返回手势
        [self.bar cancelContentAnimation];
    } else {// 自动完成了返回手势
        [self.bar popNavigationItemAnimated:YES];
    }
}

- (BOOL)isPopingByGesture:(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull) context {
    //是由侧滑手势引起的Pop
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    return ![self.viewControllers containsObject:fromVC] && context.initiallyInteractive;
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handlePopgesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *popPangesture = (UIPanGestureRecognizer *)gesture;
        if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint gesturePoint = [popPangesture locationInView:gesture.view];
            // FIXME: iPad
        CGFloat gestureProgress = gesturePoint.x * 1.2 / self.view.bounds.size.width;
        gestureProgress = gestureProgress <= 1 ? gestureProgress : 1;
        [self.bar updateContentAnimationProgress:gestureProgress];
        
        }else if (gesture.state == UIGestureRecognizerStateBegan) {
            [self.bar updateContentBeforeAnimationWithTransitionType:LSNavigationTransitionType_InteractivePop];
        }
    }
}

#pragma mark - Getter

- (LSNavigationBar *)bar {
    if (!_bar) {
        _bar = [[LSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, LS_SCREEN_SIZE.width, kLSNavigationBarHeight)];
        _bar.delegate = self;
        _bar.animationDuration = 0.3;
    }
    return _bar;
}

@end
