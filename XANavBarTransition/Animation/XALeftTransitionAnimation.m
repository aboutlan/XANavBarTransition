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
    //获取from和to控制器的view
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //将toview添加到containerView
    [transitionContext.containerView addSubview:toView];
    
    //开始做动画
    toView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    
    if(self.animationType == XAAnimTransitionTypePush){
       
        [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
            fromView.transform = CGAffineTransformTranslate(fromView.transform, -50, 0);
            toView.transform   = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            //完成转场 开启交互(completeTransition一调用会把fromView先给移除掉)
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }else{
        //POP动画通过系统自带的边缘滑动转场
        
    }
    
}

- (void)animationEnded:(BOOL)transitionCompleted{
    //回调转场完成
    if(transitionCompleted){
        !self.transitionCompletion ? : self.transitionCompletion();
    }
}

@end
