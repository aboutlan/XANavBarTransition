//
//  ThirdViewController.m
//  demo_导航栏平滑过渡
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "ThirdViewController.h"
#import "XANavBarTransition.h"
@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.xa_navBarAlpha = 0.5;
    self.title = @"3";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = [UIColor redColor];
//    vc.extendedLayoutIncludesOpaqueBars  = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
