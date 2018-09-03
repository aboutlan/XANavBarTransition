//
//  XABaseTransitionAnimation.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/22.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"
typedef NS_ENUM(NSInteger,XATransitionAnimationType){
    XAAnimTransitionTypePush,
    XAAnimTransitionTypePop
};

@interface XABaseTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) XATransitionAnimationType animationType;
@property (nonatomic, copy)   dispatch_block_t transitionCompletion;


#pragma mark - Override
- (void)performPushAnim:(id<UIViewControllerContextTransitioning>)transitionContext
               fromView:(UIView *)fromView
                 toView:(UIView *)toView;

- (void)performPopAnim:(id<UIViewControllerContextTransitioning>)transitionContext
               fromView:(UIView *)fromView
                 toView:(UIView *)toView;
@end
