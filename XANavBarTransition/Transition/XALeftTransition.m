//
//  XALeftTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XALeftTransition.h"
#import "XALeftTransitionAnimation.h"

@interface XALeftTransition()

@end

@implementation XALeftTransition
#pragma mark - Setup

- (void)setupWithNc:(UINavigationController *)nc
           delegate:(id<XATransitionDelegate>)delegate{
    [super setupWithNc:nc delegate:delegate];
    //接管系统Pop的边缘手势滑动的代理
//    self.nc.interactivePopGestureRecognizer.delegate = self;
    
}


#pragma mark - Deal
- (CGFloat)calcTransitioningX:(CGPoint)translationPoint{
    CGFloat translationX = translationPoint.x > 0 ? 0 : translationPoint.x;
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
        
        if(point.x > 0){ //向右边滑动不处理
            return NO;
        }
        
        if(![self.transitionDelegate respondsToSelector:@selector(xa_slideToNextViewController:)]){//未实现代理不处理
            return NO;
        }
        
        UIViewController *nextVc = [self.transitionDelegate xa_slideToNextViewController:self.transitionType];//是否为有效的控制器
        if(nextVc  == nil ||
           [self.nc.childViewControllers containsObject:nextVc]){
            return NO;
        }
        
        return YES;
    }
    return NO;
}


#pragma mark - Getter/Setter
- (XATransitionType)transitionType{
    return XATransitionTypeLeft;
}

- (XABaseTransitionAnimation *)pushAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}


- (XABaseTransitionAnimation *)popAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}


@end
