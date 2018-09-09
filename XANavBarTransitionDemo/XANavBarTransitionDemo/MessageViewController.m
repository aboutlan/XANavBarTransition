//
//  MessageViewController.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/9/3.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "MessageViewController.h"
#import "XANavBarTransition.h"

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.xa_transitionDelegate = self;
    
    self.view.backgroundColor  = [self randomGrayColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = [NSString stringWithFormat:@"Message-%ld",(long)self.titleIndex];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

}


- (UIColor *)randomGrayColor {
    CGFloat randomColor =  (arc4random_uniform(100) + 1) /1000.0;
    return [UIColor colorWithRed:0.9 + randomColor
                           green:0.9 + randomColor
                            blue:0.9 + randomColor
                           alpha:1.0f];
}

#pragma mark - <XATransitionDelegate>
- (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode{
    MessageViewController *msgVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MessageViewController class])];
    msgVC.titleIndex = self.titleIndex + 1;
    return msgVC;
}

@end
