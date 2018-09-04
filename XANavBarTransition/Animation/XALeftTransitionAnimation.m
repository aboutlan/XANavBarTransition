//
//  XALeftTransitionAnimation.m
//  
//
//  Created by XangAm on 2017/9/3.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "XALeftTransitionAnimation.h"

@implementation XALeftTransitionAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.35;
}

- (void)animationEnded:(BOOL)transitionCompleted{
    if(transitionCompleted){
        !self.transitionCompletion ? : self.transitionCompletion();
    }
}

- (void)performPushAnim:(id<UIViewControllerContextTransitioning>)transitionContext
               fromView:(UIView *)fromView
                 toView:(UIView *)toView{
    toView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
        fromView.transform = CGAffineTransformTranslate(fromView.transform, -50, 0);
        toView.transform   = CGAffineTransformTranslate(toView.transform, -[UIScreen mainScreen].bounds.size.width + XATransitionAnimationMargin, 0);
    }completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform   = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

- (void)performPopAnim:(id<UIViewControllerContextTransitioning>)transitionContext
              fromView:(UIView *)fromView
                toView:(UIView *)toView{
    
    toView.transform = CGAffineTransformMakeTranslation(-50, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
        fromView.transform = CGAffineTransformTranslate(fromView.transform,[UIScreen mainScreen].bounds.size.width - XATransitionAnimationMargin, 0);
        toView.transform   = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform   = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}


@end
