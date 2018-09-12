//
//  MessageViewController.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/9/3.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "MessageViewController.h"


@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.xa_transitionDelegate = self;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = [NSString stringWithFormat:@"Message-%ld",(long)self.titleIndex];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.xa_navBarAlpha = 0.4 + (self.titleIndex / 10.0);
}



#pragma mark - <XATransitionDelegate>
- (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode{
    MessageViewController *msgVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MessageViewController class])];
    msgVC.titleIndex = self.titleIndex + 1;
    return msgVC;
}

@end
