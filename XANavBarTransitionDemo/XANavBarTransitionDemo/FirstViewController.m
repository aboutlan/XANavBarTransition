//
//  FirstViewController.m
//  demo_导航栏平滑过渡
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "FirstViewController.h"
#import "XANavBarTransition.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    
}

- (void)setup{
    
    self.title = @"1";
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIViewController *vc = [[UIViewController alloc]init];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}



@end
