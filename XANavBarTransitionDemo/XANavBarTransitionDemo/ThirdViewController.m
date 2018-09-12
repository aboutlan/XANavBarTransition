//
//  ThirdViewController.m
//  demo_导航栏平滑过渡
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "ThirdViewController.h"
#import "XANavBarTransition.h"
#import "FirstViewController.h"
@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *transitionEnableBtn;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    self.title = @"3";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.xa_navBarAlpha = 0.5;
    self.transitionEnableBtn.selected =  !self.navigationController.xa_isTransitionEnable;
}

- (IBAction)transitionEnableBtnClick:(UIButton *)sender {
    BOOL enable = !self.navigationController.xa_isTransitionEnable;
    sender.selected = !enable;
    self.navigationController.xa_isTransitionEnable = enable;
  
}

- (IBAction)modelBtnClick:(UIButton *)sender {
    FirstViewController *firsetVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([FirstViewController class])];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:firsetVC];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
