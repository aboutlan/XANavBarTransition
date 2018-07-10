//
//  FirstViewController.m
//  demo_导航栏平滑过渡
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "FirstViewController.h"
#import "XANavBarTransition.h"
#import "SecondViewController.h"
@interface FirstViewController ()<XATransitionDelegate>
@property (nonatomic, strong) UIViewController *desViewController;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    self.desViewController = [[UIViewController alloc]init];
    self.desViewController.view.backgroundColor = [UIColor redColor];
    self.desViewController.xa_navBarAlpha = 0;
    self.desViewController.title = @"HomePage";
    self.desViewController.extendedLayoutIncludesOpaqueBars = YES;

    self.title = @"1";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.xa_navBarAlpha = 1;
    self.xa_transitionDelegate = self;
    self.xa_transitionType     = XATransitionTypeLeft;
}

#pragma mark - <XATransitionDelegate>
- (UIViewController *)xa_slideToNextViewController:(XATransitionType)transitionType{
     return self.desViewController;
}

@end
