//
//  ViewControllerB.m
//  LSCustomNavigationDemo
//
//  Created by 高阳 on 2018/10/29.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "ViewControllerB.h"
#import "ViewControllerC.h"
#import <LSCustomNavigation/LSCustomNavigationController.h>

@interface ViewControllerB ()<GY_CustomNavigationProtocol>

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:59./255. green:32./255. blue:12./255. alpha:1];

    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame = CGRectMake(130, 130, 100, 100);
    [pushButton setTitle:@"Push Me" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
}

- (void)pushButtonClicked {
    ViewControllerC *viewcontrollerC = [[ViewControllerC alloc] init];
    [self.navigationController pushViewController:viewcontrollerC animated:YES];
}

- (LSNavigationItem *)gy_customNavigationItem {
    LSNavigationItem *navigationItem = [[LSNavigationItem alloc] init];
    navigationItem.leftTitle = @"controllerB";
    navigationItem.title = @"Wow~";
    navigationItem.titleColor = [UIColor orangeColor];
    navigationItem.leftNormalImage = [UIImage imageNamed:@"back_white"];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    navigationItem.customTitleView = customButton;
    navigationItem.customRightView = customButton;
    
    //    navigationItem.leftTitleColor = [UIColor orangeColor];
    //    navigationItem.hideBackButton = YES;
    //    navigationItem.barBackgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.6];
    navigationItem.barBackgroundColor = [UIColor purpleColor];
    navigationItem.barTransparent = YES;
    
    navigationItem.barHeight = 120;
    
    return navigationItem;
}
@end
