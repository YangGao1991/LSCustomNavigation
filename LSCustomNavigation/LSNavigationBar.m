//
//  GYNavigationBar.m
//  CustomNavigation
//
//  Created by 高阳 on 2018/10/15.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "LSNavigationBar.h"
#import "LSNavigationAnimationGroup.h"
#import "UIView+LSConstraints.h"
#import "UIColor+LCTransition.h"

static NSString *backButtonAnimationKey = @"backButtonAnimationKey";
static NSString *appearanceAnimationKey = @"appearanceAnimationKey";
static NSString *titleViewAnimationKey = @"titleViewAnimationKey";
static NSString *backgroundImageAnimationKey = @"backgroundImageAnimationKey";


static NSString *backButtonElementKey = @"backElement";
static NSString *titleLabelElementKey = @"titleLabelElement";
static NSString *titleCustomElementKey = @"titleCustomElementKey";
static NSString *rightCustomElementKey = @"rightCustomElementKey";
static NSString *backgroundImageElementKey = @"backgroundImageElementKey";


#define IS_IPAD ([[UIDevice currentDevice].model isEqualToString:@"iPad"])
#define LSNavigationTitleAnimationLength (IS_IPAD ? 500 : 200)
#define LSNavigationSideMargin 16

@interface LSNavigationBar ()

@property (nonatomic, strong) NSMutableArray<LSNavigationItem *> *innerItems;
@property (nonatomic, strong) UIButton *backButton1;
@property (nonatomic, strong) UIButton *backButton2;
@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UIImageView *backgroundImageView1;
@property (nonatomic, strong) UIImageView *backgroundImageView2;

@property (nonatomic, strong) LSNavigationAnimationGroup *sideGroup1;
@property (nonatomic, strong) LSNavigationAnimationGroup *sideGroup2;
@property (nonatomic, strong) LSNavigationAnimationGroup *titleGroup1;
@property (nonatomic, strong) LSNavigationAnimationGroup *titleGroup2;
@property (nonatomic, strong) LSNavigationAnimationGroup *backgroundImageGroup1;
@property (nonatomic, strong) LSNavigationAnimationGroup *backgroundImageGroup2;


@property (nonatomic, strong) UIColor *lastBackgroundColor;
@property (nonatomic, assign) CGFloat lastBackgroundColorAlphaComponent;
@property (nonatomic, assign) CGFloat lastAlpha;
@property (nonatomic, assign) CGFloat lastBarHeight;

@end


@implementation LSNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.innerItems = [NSMutableArray array];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [self addSubview:self.backgroundImageView1];
        [self addSubview:self.backgroundImageView2];
        [self addSubview:self.backButton1];
        [self addSubview:self.backButton2];
        [self addSubview:self.titleLabel1];
        [self addSubview:self.titleLabel2];
        
        self.sideGroup1 = [[LSNavigationAnimationGroup alloc] initWithElements:@{backButtonElementKey : self.backButton1}];
        self.sideGroup2 = [[LSNavigationAnimationGroup alloc] initWithElements:@{backButtonElementKey : self.backButton2}];
        
        self.titleGroup1 = [[LSNavigationAnimationGroup alloc] initWithElements:@{titleLabelElementKey : self.titleLabel1}];
        self.titleGroup2 = [[LSNavigationAnimationGroup alloc] initWithElements:@{titleLabelElementKey : self.titleLabel2}];
        
        self.backgroundImageGroup1 = [[LSNavigationAnimationGroup alloc] initWithElements:@{backgroundImageElementKey : self.backgroundImageView1}];
        self.backgroundImageGroup2 = [[LSNavigationAnimationGroup alloc] initWithElements:@{backgroundImageElementKey : self.backgroundImageView2}];

        
        [self addConstraints];
    }
    return self;
}

- (void)addConstraints {
    self.backgroundImageView1.ls_verticalConstraint.active = YES;
    self.backgroundImageView1.ls_horizonConstraint.active = YES;
    
    self.backgroundImageView2.ls_verticalConstraint.active = YES;
    self.backgroundImageView2.ls_horizonConstraint.active = YES;
    
    self.backButton1.ls_verticalConstraint.active = YES;
    self.backButton2.ls_verticalConstraint.active = YES;
    self.backButton1.ls_horizonConstraint.active = YES;
    self.backButton2.ls_horizonConstraint.active = YES;
    
    self.titleLabel1.ls_verticalConstraint.active = YES;
    self.titleLabel2.ls_verticalConstraint.active = YES;
    self.titleLabel1.ls_horizonConstraint.active = YES;
    self.titleLabel2.ls_horizonConstraint.active = YES;
}

#pragma mark - Items Operation

- (LSNavigationItem *)topItem {
    return [self.innerItems lastObject];
}

- (LSNavigationItem *)itemTransitionToWithTransitionType:(LSNavigationTransitionType)transitionType {
    LSNavigationItem *anotherItem = nil;
    switch (transitionType) {
        case LSNavigationTransitionType_InteractivePop:
        {
            if (self.innerItems.count >= 2) {
                anotherItem = [self.innerItems objectAtIndex:self.innerItems.count - 2];
            }
        }
            break;
        case LSNavigationTransitionType_Push:
        case LSNavigationTransitionType_Pop:
        {
            anotherItem = self.topItem;
        }
            break;
    }
    return anotherItem;
}

- (void)pushNavigationItem:(LSNavigationItem *)item animated:(BOOL)animated {
    if (!item) {
        return;
    }
    [self.innerItems addObject:item];
    [self updateContentWithTransitionType:LSNavigationTransitionType_Push animated:animated];
}

- (LSNavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    if (_innerItems.count == 0) {
        return nil;
    }
    LSNavigationItem *item = [_innerItems lastObject];
    [_innerItems removeLastObject];
    [self updateContentWithTransitionType:LSNavigationTransitionType_Pop animated:animated];
    return item;
}

#pragma mark - UI Content

- (void)updateContentWithTransitionType:(LSNavigationTransitionType)transitionType animated:(BOOL)animated {
    // 初始状态更新
    [self updateContentBeforeAnimationWithTransitionType:transitionType];
    
    // 动画
    [self updateAppearanceAnimated:animated];
    [self updateSideGroupAnimated:animated];
    [self updateTitleViewWithTransitionType:transitionType animated:animated];
    [self updateBackgroundImageGroupAnimated:animated];
}

- (void)updateContentBeforeAnimationWithTransitionType:(LSNavigationTransitionType)transitionType {
    [self updateTitleGroupBeforeAnimationWithTransitionType:transitionType];
    [self updateSideGroupBeforeAnimationWithTransitionType:transitionType];
    [self updateAppearanceStateBeforeAnimation];
    [self updateBackgroundImageBeforeAnimationWithTransitionType:transitionType];
    
}

- (void)updateContentAnimationProgress:(CGFloat)progress {
    [self updateSideGroupAnimationProgress:progress];
    [self updateTitleGroupAnimationProgress:progress transitionType:LSNavigationTransitionType_InteractivePop];
    [self updateAppearanceAnimationProgress:progress transitionType:LSNavigationTransitionType_InteractivePop];
    [self updateBackgroundImageGroupAnimationProgress:progress];
}

- (void)cancelContentAnimation {
    [self cancelSideGroupAnimation];
    [self cancelTitleGroupAnimation];
    [self cancelAppearanceAnimation];
    [self cancelBackgroundImageGroupAnimation];
}

#pragma mark - Side Elements

- (void)updateSideGroupBeforeAnimationWithTransitionType:(LSNavigationTransitionType)transitionType {
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.sideGroup1.active) {
        currentGroup = self.sideGroup1;
        anotherGroup = self.sideGroup2;
    }else {
        currentGroup = self.sideGroup2;
        anotherGroup = self.sideGroup1;
    }
    LSNavigationItem *anotherItem = [self itemTransitionToWithTransitionType:transitionType];
    UIButton *anotherButton = [anotherGroup elementForKey:backButtonElementKey];
    
    if (anotherItem && (!anotherItem.isBackButtonHidden) && (!anotherItem.isBarHidden)) {
        NSString *backTitle = (anotherItem.leftTitle && anotherItem.leftTitle.length > 0) ? anotherItem.leftTitle : @"";
        [anotherButton setImage:anotherItem.leftNormalImage forState:UIControlStateNormal];
        [anotherButton setImage:anotherItem.leftHighligtedImage forState:UIControlStateHighlighted];
        [anotherButton setTitle:backTitle forState:UIControlStateNormal];
        [anotherButton setTitle:backTitle forState:UIControlStateHighlighted];
        [anotherButton setTitleColor:anotherItem.leftTitleColor forState:UIControlStateNormal];
        anotherButton.titleLabel.font = anotherItem.leftTitleFont;
        CGFloat verticalConstant = (anotherItem.isStatusBarHidden ? 0 : kLSStatusBarHeight / 2) + anotherItem.leftViewShifting.y;
        anotherButton.ls_verticalConstraint.constant = verticalConstant;
        anotherButton.ls_horizonConstraint.constant = LSNavigationSideMargin + anotherItem.leftViewShifting.x;
        anotherButton.hidden = NO;
        if (anotherItem.customLeftButtonAction) {
            [anotherButton addTarget:self
                              action:@selector(doCustomLeftButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        }else {
            [anotherButton addTarget:self
                              action:@selector(backButtonClicked)
                    forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        anotherButton.hidden = YES;
    }
    
    if (anotherItem && anotherItem.customRightView) {
        UIView *customRightView = anotherItem.customRightView;
        [self addSubview:customRightView];
        customRightView.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat verticalConstant = (anotherItem.isStatusBarHidden ? 0 : kLSStatusBarHeight / 2) + anotherItem.rightViewShifting.y;
        customRightView.ls_verticalConstraint = [self verticalConstraintForSubview:customRightView
                                                                          constant:verticalConstant];
        customRightView.ls_verticalConstraint.active = YES;
        customRightView.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:customRightView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1
                                                                          constant:-LSNavigationSideMargin + anotherItem.rightViewShifting.x];
        customRightView.ls_horizonConstraint.active = YES;
        [anotherGroup addElement:customRightView forKey:rightCustomElementKey];
    }
    [self layoutIfNeeded];
}

- (void)updateSideGroupAnimationProgress:(CGFloat)progress {
    // 交互式动画（右划手势）
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.sideGroup1.active) {
        currentGroup = self.sideGroup1;
        anotherGroup = self.sideGroup2;
    }else {
        currentGroup = self.sideGroup2;
        anotherGroup = self.sideGroup1;
    }
    
    [currentGroup setAlpha:1 - progress];
    [anotherGroup setAlpha:progress];
}

- (void)updateSideGroupAnimated:(BOOL)animated {
    // 非交互式动画
    if (animated) {
        [UIView beginAnimations:backButtonAnimationKey context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(updateSideGroupStateAfterAnimation)];
    }
    // 直接完成动画
    [self updateSideGroupAnimationProgress:1];

    if (animated) {
        [UIView commitAnimations];
    }else {
        [self updateSideGroupStateAfterAnimation];
    }
}

- (void)cancelSideGroupAnimation {
    [UIView beginAnimations:backButtonAnimationKey context:nil];
    // FIXME: time duration
    [UIView setAnimationDuration:self.animationDuration];
    // 直接完成动画
    [self updateSideGroupAnimationProgress:0];
    [UIView commitAnimations];
}

- (void)updateSideGroupStateAfterAnimation {
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.sideGroup1.active) {
        currentGroup = self.sideGroup1;
        anotherGroup = self.sideGroup2;
    }else {
        currentGroup = self.sideGroup2;
        anotherGroup = self.sideGroup1;
    }
    currentGroup.active = NO;
    anotherGroup.active = YES;
    if ([currentGroup elementForKey:rightCustomElementKey]) {
        [[currentGroup elementForKey:rightCustomElementKey] removeFromSuperview];
    }
}

#pragma mark - Bar Appearance

- (void)updateAppearanceStateBeforeAnimation {
    self.lastBackgroundColor = self.backgroundColor;
    self.lastBarHeight = self.frame.size.height;
    self.lastBackgroundColorAlphaComponent = [self.lastBackgroundColor ls_getAlphaValue];
    self.lastAlpha = self.alpha;
}

- (void)updateAppearanceAnimated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:appearanceAnimationKey context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(updateAppearanceStateAfterAnimation)];
    }
    [self updateAppearanceAnimationProgress:1 transitionType:LSNavigationTransitionType_Pop];
    if (animated) {
        [UIView commitAnimations];
    }else {
        [self updateAppearanceStateAfterAnimation];
    }
}

- (void)updateAppearanceAnimationProgress:(CGFloat)progress transitionType:(LSNavigationTransitionType)transitionType {
    LSNavigationItem *toItem = [self itemTransitionToWithTransitionType:transitionType];
    
    // 尽量保持和谐过渡
    UIColor *toColor = (toItem.barTransparent || toItem.isBarHidden) ? self.lastBackgroundColor : toItem.barBackgroundColor;
    UIColor *currentColor = [UIColor ls_transitionColorFromColor:self.lastBackgroundColor
                                                      toColor:toColor
                                                     progress:progress];
    CGFloat toBackgroundAlpha = (toItem.barTransparent || toItem.isBarHidden) ? 0 : (toItem.barTranslucent ? 0.7 : 1);
    CGFloat currentAlpha = (toBackgroundAlpha - _lastBackgroundColorAlphaComponent) * progress + _lastBackgroundColorAlphaComponent;
    self.backgroundColor = [currentColor colorWithAlphaComponent:currentAlpha];
    
    CGFloat toAlpha = toItem.isBarHidden ? 0 : 1;
    self.alpha = (toAlpha - _lastAlpha) * progress + _lastAlpha;

    if (toItem.barHeight > 0) {
        CGFloat currentHeight = (toItem.barHeight - _lastBarHeight) * progress + _lastBarHeight;
        CGRect currentFrame = self.frame;
        currentFrame.size.height = currentHeight;
        self.frame = currentFrame;
    }
}

- (void)cancelAppearanceAnimation {
    [UIView beginAnimations:appearanceAnimationKey context:nil];
    // FIXME: time duration
    [UIView setAnimationDuration:self.animationDuration];
    // 直接完成动画
    [self updateAppearanceAnimationProgress:0 transitionType:LSNavigationTransitionType_Push];
    [UIView commitAnimations];
}

- (void)updateAppearanceStateAfterAnimation {
//    self.lastBackgroundColor = self.backgroundColor;
}

#pragma mark - Background image

- (void)updateBackgroundImageBeforeAnimationWithTransitionType:(LSNavigationTransitionType)transitionType {
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.backgroundImageGroup1.active) {
        currentGroup = self.backgroundImageGroup1;
        anotherGroup = self.backgroundImageGroup2;
    }else {
        currentGroup = self.backgroundImageGroup2;
        anotherGroup = self.backgroundImageGroup1;
    }
    LSNavigationItem *anotherItem = [self itemTransitionToWithTransitionType:transitionType];
    if (anotherItem && anotherItem.barBackgroundImage) {
        UIImageView *anotherBackgroundImageView = [anotherGroup elementForKey:backgroundImageElementKey];
        anotherBackgroundImageView.image = anotherItem.barBackgroundImage;
    }
}

- (void)updateBackgroundImageGroupAnimationProgress:(CGFloat)progress {
    // 交互式动画（右划手势）
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.backgroundImageGroup1.active) {
        currentGroup = self.backgroundImageGroup1;
        anotherGroup = self.backgroundImageGroup2;
    }else {
        currentGroup = self.backgroundImageGroup2;
        anotherGroup = self.backgroundImageGroup1;
    }
    
    [currentGroup setAlpha:1 - progress];
    [anotherGroup setAlpha:progress];
}

- (void)updateBackgroundImageGroupAnimated:(BOOL)animated {
    // 非交互式动画
    if (animated) {
        [UIView beginAnimations:backgroundImageAnimationKey context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(updateBackgroundImageGroupStateAfterAnimation)];
    }
    // 直接完成动画
    [self updateBackgroundImageGroupAnimationProgress:1];
    
    if (animated) {
        [UIView commitAnimations];
    }else {
        [self updateBackgroundImageGroupStateAfterAnimation];
    }
}

- (void)cancelBackgroundImageGroupAnimation {
    [UIView beginAnimations:backgroundImageAnimationKey context:nil];
    // FIXME: time duration
    [UIView setAnimationDuration:self.animationDuration];
    // 直接完成动画
    [self updateBackgroundImageGroupAnimationProgress:0];
    [UIView commitAnimations];
}

- (void)updateBackgroundImageGroupStateAfterAnimation {
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.backgroundImageGroup1.active) {
        currentGroup = self.backgroundImageGroup1;
        anotherGroup = self.backgroundImageGroup2;
    }else {
        currentGroup = self.backgroundImageGroup2;
        anotherGroup = self.backgroundImageGroup1;
    }
    currentGroup.active = NO;
    anotherGroup.active = YES;
}

#pragma mark - Title View

- (void)updateTitleGroupBeforeAnimationWithTransitionType:(LSNavigationTransitionType)transitionType {
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.titleGroup1.active) {
        currentGroup = self.titleGroup1;
        anotherGroup = self.titleGroup2;
    }else {
        currentGroup = self.titleGroup2;
        anotherGroup = self.titleGroup1;
    }
    UILabel *anotherTitleLabel = [anotherGroup elementForKey:titleLabelElementKey];
    
    LSNavigationItem *anotherItem = [self itemTransitionToWithTransitionType:transitionType];
    UIView *customTitleView = anotherItem.customTitleView;
    if (customTitleView) {
        [self addSubview:customTitleView];
        customTitleView.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat verticalConstant = (anotherItem.isStatusBarHidden ? 0 : kLSStatusBarHeight / 2) + anotherItem.titleViewShifting.y;

        customTitleView.ls_verticalConstraint = [self verticalConstraintForSubview:customTitleView
                                                                          constant:verticalConstant];
        customTitleView.ls_verticalConstraint.active = YES;
        customTitleView.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:customTitleView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1
                                                                          constant:anotherItem.titleViewShifting.x];
        customTitleView.ls_horizonConstraint.active = YES;
        [anotherGroup addElement:anotherItem.customTitleView forKey:titleCustomElementKey];
        anotherTitleLabel.hidden = YES;
    }else {
        anotherTitleLabel.hidden = anotherItem.isBarHidden;
        CGFloat verticalConstant = (anotherItem.isStatusBarHidden ? 0 : kLSStatusBarHeight / 2) + anotherItem.titleViewShifting.y;
        anotherTitleLabel.ls_verticalConstraint.constant = verticalConstant;
    }
    
    switch (transitionType) {
        case LSNavigationTransitionType_InteractivePop:
        {
            anotherTitleLabel.ls_horizonConstraint.constant = 0;
            customTitleView.ls_horizonConstraint.constant = 0;
        }
            break;
        case LSNavigationTransitionType_Push:
        {
            anotherTitleLabel.ls_horizonConstraint.constant = LSNavigationTitleAnimationLength;
            customTitleView.ls_horizonConstraint.constant = LSNavigationTitleAnimationLength;
        }
            break;
        case LSNavigationTransitionType_Pop:
        {
            anotherTitleLabel.ls_horizonConstraint.constant = 0;
            customTitleView.ls_horizonConstraint.constant = 0;
        }
            break;
    }
    
    if (anotherItem && (!customTitleView)) {
        NSString *title = (anotherItem.title && anotherItem.title.length > 0) ? anotherItem.title : @"";
        anotherTitleLabel.text = title;
        anotherTitleLabel.font = anotherItem.titleFont;
        anotherTitleLabel.textColor = anotherItem.titleColor;
    }
    [self layoutIfNeeded];
}

- (void)updateTitleGroupAnimationProgress:(CGFloat)progress transitionType:(LSNavigationTransitionType)transitionType {
    // 交互式动画（右划手势）
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.titleGroup1.active) {
        currentGroup = self.titleGroup1;
        anotherGroup = self.titleGroup2;
    }else {
        currentGroup = self.titleGroup2;
        anotherGroup = self.titleGroup1;
    }
    UILabel *currentTitleLabel = [currentGroup elementForKey:titleLabelElementKey];
    UILabel *anotherTitleLabel = [anotherGroup elementForKey:titleLabelElementKey];
    UIView *currentCustomView = [currentGroup elementForKey:titleCustomElementKey];
    UIView *anotherCustomView = [anotherGroup elementForKey:titleCustomElementKey];
    
    switch (transitionType) {
        case LSNavigationTransitionType_Push:
        {
            [currentGroup setAlpha:1 - progress];
//            if (self.topItem.titleView) {
//                [self addSubview:self.topItem.titleView];
//            }else {
                anotherCustomView.ls_horizonConstraint.constant = LSNavigationTitleAnimationLength * (1 - progress);
                anotherTitleLabel.ls_horizonConstraint.constant = LSNavigationTitleAnimationLength * (1 - progress);
                [anotherGroup setAlpha:progress];
//            }
        }
            break;
        case LSNavigationTransitionType_Pop:
        case LSNavigationTransitionType_InteractivePop:
        {
            [currentGroup setAlpha:1 - progress];
            currentTitleLabel.ls_horizonConstraint.constant = LSNavigationTitleAnimationLength * progress;
            currentCustomView.ls_horizonConstraint.constant = LSNavigationTitleAnimationLength * progress;
            [anotherGroup setAlpha:progress];
        }
            break;
    }
    
}

- (void)updateTitleViewWithTransitionType:(LSNavigationTransitionType)transitionType animated:(BOOL)animated {
    
    if (animated) {
        [UIView beginAnimations:titleViewAnimationKey context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(updateTitleGroupStateAfterAnimation)];
    }
    
    // 直接完成动画
    [self updateTitleGroupAnimationProgress:1 transitionType:transitionType];
    
    [self layoutIfNeeded];
    if (animated) {
        [UIView commitAnimations];
    }else {
        [self updateTitleGroupStateAfterAnimation];
    }
}

- (void)cancelTitleGroupAnimation {
    [UIView beginAnimations:titleViewAnimationKey context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    // FIXME: time duration
    [UIView setAnimationDuration:self.animationDuration];
    
    // 直接完成动画
    [self updateTitleGroupAnimationProgress:0 transitionType:LSNavigationTransitionType_Pop];
    
    [self layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)updateTitleGroupStateAfterAnimation {
    LSNavigationAnimationGroup *currentGroup, *anotherGroup;
    if (self.titleGroup1.active) {
        currentGroup = self.titleGroup1;
        anotherGroup = self.titleGroup2;
    }else {
        currentGroup = self.titleGroup2;
        anotherGroup = self.titleGroup1;
    }
    currentGroup.active = NO;
    anotherGroup.active = YES;
    if ([currentGroup elementForKey:titleCustomElementKey]) {
        [[currentGroup elementForKey:titleCustomElementKey] removeFromSuperview];
    }
}

#pragma mark - Actions

- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedBackButton)]) {
        [self.delegate didClickedBackButton];
    }
}

- (void)doCustomLeftButtonAction:(id)sender {
    LSNavigationItem *currentItem = [self topItem];
    if (currentItem && currentItem.customLeftButtonAction) {
        currentItem.customLeftButtonAction(sender);
    }
}

#pragma mark - Getter

- (UIButton *)backButton1 {
    if (!_backButton1) {
        _backButton1 = [self backButton];
        _backButton1.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:_backButton1
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1
                                                                       constant:LSNavigationSideMargin];
    }
    return _backButton1;
}

- (UIButton *)backButton2 {
    if (!_backButton2) {
        _backButton2 = [self backButton];
        _backButton2.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:_backButton2
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1
                                                                       constant:LSNavigationSideMargin];
    }
    return _backButton2;
}

- (UIButton *)backButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    backButton.ls_verticalConstraint = [self verticalConstraintForSubview:backButton constant:kLSStatusBarHeight / 2];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [self titleLabel];
        _titleLabel1.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:_titleLabel1
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1
                                                                       constant:0];
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [self titleLabel];
        _titleLabel2.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:_titleLabel2
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1
                                                                       constant:0];
    }
    return _titleLabel2;
}

- (UILabel *)titleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.ls_verticalConstraint = [self verticalConstraintForSubview:titleLabel constant:kLSStatusBarHeight / 2];
    return titleLabel;
}

- (UIImageView *)backgroundImageView1 {
    if (!_backgroundImageView1) {
        _backgroundImageView1 = [self backgroundImageView];
    }
    return _backgroundImageView1;
}

- (UIImageView *)backgroundImageView2 {
    if (!_backgroundImageView2) {
        _backgroundImageView2 = [self backgroundImageView];
    }
    return _backgroundImageView2;
}

- (UIImageView *)backgroundImageView {
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundImageView.ls_horizonConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeWidth
                                                                            multiplier:1
                                                                              constant:0];
    backgroundImageView.ls_verticalConstraint = [NSLayoutConstraint constraintWithItem:backgroundImageView
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeHeight
                                                                             multiplier:1
                                                                               constant:0];
    return backgroundImageView;
}

- (NSLayoutConstraint *)verticalConstraintForSubview:(UIView *)subview constant:(CGFloat)constant{
    return [NSLayoutConstraint constraintWithItem:subview
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1
                                         constant:constant];
}

@end
