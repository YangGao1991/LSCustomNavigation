//
//  ViewController.m
//  LSCustomNavigationDemo
//
//  Created by 高阳 on 2018/10/29.
//  Copyright © 2018 高阳. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerB.h"
#import <LSCustomNavigation/LSCustomNavigationController.h>

@interface ViewController ()<LSCustomNavigationProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:237./255. green:227./255. blue:135./255. alpha:1];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame = CGRectMake(130, 130, 100, 100);
    [pushButton setTitle:@"Push Me" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
}

- (void)pushButtonClicked {
    ViewControllerB *viewcontrollerB = [[ViewControllerB alloc] init];
    [self.navigationController pushViewController:viewcontrollerB animated:YES];
}

- (LSNavigationItem *)ls_customNavigationItem {
    LSNavigationItem *navigationItem = [[LSNavigationItem alloc] init];
    navigationItem.leftTitle = @"VCA";
    navigationItem.title = @"This is A";
    navigationItem.titleColor = [UIColor orangeColor];
    navigationItem.leftTitleColor = [UIColor orangeColor];
    UISwitch *UIswitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    navigationItem.customTitleView = UIswitch;
    navigationItem.barTranslucent = NO;
    //    navigationItem.hideBackButton = YES;
    navigationItem.barBackgroundColor = [UIColor cyanColor];
    return navigationItem;
}


@end
