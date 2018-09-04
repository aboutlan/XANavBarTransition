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
#import "MessageViewController.h"
@interface FirstViewController ()<XATransitionDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    self.title = @"1";
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.xa_navBarAlpha = 1;
    self.xa_transitionDelegate = self;
//    self.xa_transitionMode     = XATransitionModeLeft;
    self.xa_transitionMode     = XATransitionModeRight;
}

#pragma mark - <XATransitionDelegate>
- (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode{
    if(transitionMode == XATransitionModeLeft){
        SecondViewController *secondVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SecondViewController class])];
        return secondVC;
    }else{
        MessageViewController *msgVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MessageViewController class])];
        return msgVC;
    }

}

@end
