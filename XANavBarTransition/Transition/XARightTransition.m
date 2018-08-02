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
- (CGFloat)calcTransitioningX:(CGPoint)translationPoint{
    CGFloat translationX = translationPoint.x < 0 ? 0 : translationPoint.x;
    return translationX;
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
      
        
        return YES;
    }
    return NO;
}


#pragma mark - Getter/Setter
- (XATransitionType)transitionType{
    return XATransitionTypeRight;
}


- (XABaseTransitionAnimation *)pushAnimation{
    if(_animation == nil){
        _animation = ({
             XARightTransitionAnimation *animation =  [[XARightTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}


- (XABaseTransitionAnimation *)popAnimation{
    if(_animation == nil){
        _animation = ({
            XARightTransitionAnimation *animation =  [[XARightTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}

@end
