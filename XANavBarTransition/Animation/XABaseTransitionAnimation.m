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
    UIViewController *toVC =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
  
    //适配iOS12:在iOS12的该方法中toView拿到的尺寸为控制器extendedLayoutIncludesOpaqueBars属性设置之前的尺寸(控制器的View以Top Layout Guide为原点坐标轴)。
    //解决方案:在这里将其恢复为控制器extendedLayoutIncludesOpaqueBars属性设置之后的尺寸。(控制器的Viewt以左上角为原点坐标抽)
    if (@available(iOS 12.0, *)){
        if(toVC.extendedLayoutIncludesOpaqueBars){
            CGRect screenBounds = [UIScreen mainScreen].bounds;
            CGRect toViewFrame = toView.frame;
            toViewFrame.origin.y = 0;
            toViewFrame.size.height = screenBounds.size.height;
            toView.frame = toViewFrame;
        }
    }
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
