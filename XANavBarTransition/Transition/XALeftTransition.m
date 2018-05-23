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
        
        if(![self.nc.xa_transitionDelegate respondsToSelector:@selector(xa_slideToNextViewController:transitionType:)]){//未实现代理不处理
            return NO;
        }
        
        return YES;
    }
    
    //    //        if (self.viewControllers.count <= 1) {
    //    //            return NO;
    //    //        }
    //
    //    //没有开启滑动不允许使用手势
    //    if (!self.transitionEnable) {
    //        return NO;
    //    }
    //
    //
    //    //不是右滑不允许使用手势
    //    CGPoint point = [gestureRecognizer translationInView:nil];
    //    if(!(point.x >= 0 && point.y == 0)){
    //        return NO;
    //    }
    //
    //    //正在做转场不允许使用手势
    //
    //    //        if([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]){
    //    //
    //    //            return NO;
    //    //        }
    //
    //    //        [self setPanGrPop:YES];
    //
    //    return YES ;
    
    
    //
    //    else{//全屏push手势
    
    //    }
    return NO;
}


#pragma mark - Getter/Setter
- (TransitionType)transitionType{
    return TransitionTypeLeft;
}

- (XABaseTransitionAnimation *)animation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}
@end
