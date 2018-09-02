//
//  XALeftTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XALeftTransition.h"
#import "XALeftTransitionAnimation.h"
#import "XATransitionManager.h"
@interface XALeftTransition()
//@property (nonatomic, weak) id<UIGestureRecognizerDelegate> interactivePopDelegate;
@end

@implementation XALeftTransition


#pragma mark - Action
- (void)interactiveTransitioningEvent:(UIPanGestureRecognizer *)pan{
    
    if(pan == self.interactivePan){
        static NSTimeInterval beginTouchTime,endTouchTime;//beginTouchTime和endTouchTime这两个数据量主要是用于参考是否为轻扫
        CGPoint translationPoint = [pan translationInView:self.transitionView];
        CGFloat progress  = fabs(translationPoint.x / [UIScreen mainScreen].bounds.size.width) ;
        progress = MIN(1, MAX(progress, 0));
        if (pan.state == UIGestureRecognizerStateBegan) {
            beginTouchTime = [[NSDate date]timeIntervalSince1970];
            self.nc.xa_Transitioning = YES;
            if(translationPoint.x < 0){//push
                [self.nc pushViewController:self.nextVC animated:YES];
            }else{//pop
                [self.nc popViewControllerAnimated:YES];
            }
            [self.percentInteractive updateInteractiveTransition:0];
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            
            [self.percentInteractive updateInteractiveTransition:progress];
            
        } else if (pan.state == UIGestureRecognizerStateEnded) {
            self.nc.xa_Transitioning = NO;
            endTouchTime = [[NSDate date]timeIntervalSince1970];
            CGFloat dValueTime = endTouchTime - beginTouchTime;
            if (progress > 0.3 || dValueTime <= 0.15f) {//dValueTime <= 0.15f 该条件用于判断是否为轻扫
                [self.percentInteractive finishInteractiveTransition];
            } else {
                [self.percentInteractive cancelInteractiveTransition];
            }
            self.percentInteractive = nil;
        }
    }
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer == self.interactivePan){
        CGPoint point     = [gestureRecognizer translationInView:nil];
        CGPoint velocity  = [gestureRecognizer velocityInView:nil];
        
        if (fabs(velocity.y) > fabs(velocity.x)) {//垂直方向不处理
            return NO;
        }
        
        if(point.x < 0){//push
            self.nextVC = [self.transitionDelegate xa_nextViewControllerInTransitionMode:self.transitionMode];//是否为有效的push控制器
            if(self.nextVC  == nil ||
               [self.nc.childViewControllers containsObject:self.nextVC]){
                return NO;
            }
            return self.pushTransitionEnable;
        }else{//pop
            
            
            if(self.nc.viewControllers.count <= 1){//栈底控制器不处理
                return NO;
            }
           return self.popTransitionEnable;
        }
    }
    return YES;
}

#pragma mark - Getter/Setter
- (XATransitionMode)transitionMode{
    return XATransitionModeLeft;
}

- (XABaseTransitionAnimation *)pushAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation.animationType = XAAnimTransitionTypePush;
            animation;
        });
    }
    return _animation;
}


- (XABaseTransitionAnimation *)popAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation.animationType = XAAnimTransitionTypePop;
            animation;
        });
    }
    return _animation;
}

@end
