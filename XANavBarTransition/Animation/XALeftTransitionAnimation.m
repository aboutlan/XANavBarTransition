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


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:toView];
    
    toView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    if(self.animationType == XAAnimTransitionTypePush){
        [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
            fromView.transform = CGAffineTransformTranslate(fromView.transform, -50, 0);
            toView.transform   = CGAffineTransformTranslate(toView.transform, -[UIScreen mainScreen].bounds.size.width + 10, 0);
        }completion:^(BOOL finished) {
            toView.transform   = CGAffineTransformIdentity;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }else{
        //POP动画通过系统自带的边缘滑动转场
        
    }
    
}

- (void)animationEnded:(BOOL)transitionCompleted{
    if(transitionCompleted){
        !self.transitionCompletion ? : self.transitionCompletion();
    }
}

@end
