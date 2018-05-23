//
//  XARightTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/23.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XARightTransition.h"
#import "XARightTransitionAnimation.h"
@implementation XARightTransition


#pragma mark - Deal
- (CGFloat)calcTransitioningProgress:(CGPoint)translationPoint{
    CGFloat x = translationPoint.x < 0 ? 0 : translationPoint.x;
    CGFloat progress = fabs(x / [UIScreen mainScreen].bounds.size.width) * 1.2;
    NSLog(@"progress:%lf,x:%lf",progress,x);
    progress = MIN(1, MAX(progress, 0));
    return progress;
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer == self.interactivePan){
        CGPoint point    = [gestureRecognizer translationInView:nil];
        CGPoint velocity = [gestureRecognizer velocityInView:nil];
        
        if(!self.transitionEnable){
            return NO;
        }
        
        if (fabs(velocity.y) > fabs(velocity.x)) {//垂直方向不处理
            return NO;
        }
        
        if(point.x < 0){ //向左边滑动不处理
            return NO;
        }
        
        if(![self.nc.xa_transitionDelegate respondsToSelector:@selector(xa_slideToNextViewController:transitionType:)]){//未实现代理不处理
            return NO;
        }
        
        return YES;
    }
    return NO;
}



#pragma mark - Getter/Setter
- (TransitionType)transitionType{
    return TransitionTypeRight;
}

- (XABaseTransitionAnimation *)animation{
    if(_animation == nil){
        _animation = ({
            XARightTransitionAnimation *animation =  [[XARightTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}

@end
