//
//  XABaseTransitionAnimation.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/22.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XABaseTransitionAnimation.h"

@implementation XABaseTransitionAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0;
    
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if(self.animationType == XAAnimTransitionTypePush){
        [transitionContext.containerView addSubview:fromView];
        [transitionContext.containerView addSubview:toView];
        [self performPushAnim:transitionContext fromView:fromView toView:toView];
        
    }else{
        [transitionContext.containerView addSubview:toView];
        [transitionContext.containerView insertSubview:fromView aboveSubview:toView];
        [self performPopAnim:transitionContext fromView:fromView toView:toView];
    }
    
}

- (void)performPushAnim:(id<UIViewControllerContextTransitioning>)transitionContext
               fromView:(UIView *)fromView
                 toView:(UIView *)toView{
    
    
}

- (void)performPopAnim:(id<UIViewControllerContextTransitioning>)transitionContext
              fromView:(UIView *)fromView
                toView:(UIView *)toView{
    
    
    
}
@end
