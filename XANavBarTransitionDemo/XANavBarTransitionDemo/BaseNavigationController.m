//
//  BaseNavigationController.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化导航栏,设置导航栏颜色
    self.navigationBar.translucent  = NO;
    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.shadowImage  = [UIImage new];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                 }];
    
    
}



@end
