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
    if(pan == self.pushInteractivePan){
        static NSTimeInterval beginTouchTime,endTouchTime;//beginTouchTime和endTouchTime这两个数据量主要是用于参考是否为轻扫
        CGPoint translationPoint = [pan translationInView:self.transitionView];
        CGFloat translationX = [self calcTransitioningX:translationPoint];
        CGFloat progress     = fabs(translationX / [UIScreen mainScreen].bounds.size.width) * 1.2;
        progress = MIN(1, MAX(progress, 0));
        if (pan.state == UIGestureRecognizerStateBegan) {
            beginTouchTime = [[NSDate date]timeIntervalSince1970];
            self.nc.xa_Transitioning = YES;
            [self.nc pushViewController:self.nextVC animated:YES];
            [self.interactive updateInteractiveTransition:0];
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            
            [self.interactive updateInteractiveTransition:progress];
            
        } else if (pan.state == UIGestureRecognizerStateEnded) {
            self.nc.xa_Transitioning = NO;
            endTouchTime = [[NSDate date]timeIntervalSince1970];
            CGFloat dValueTime = endTouchTime - beginTouchTime;
            if (progress > 0.3 || dValueTime <= 0.15f) {//dValueTime <= 0.15f 该条件用于判断是否为轻扫
                [self.interactive finishInteractiveTransition];
            } else {
                [self.interactive cancelInteractiveTransition];
            }
            self.interactive = nil;
        }
        
    }else  if(pan == self.popInteractivePan){
        
        if (pan.state == UIGestureRecognizerStateBegan) {
            self.nc.xa_Transitioning = YES;
            
        }  else if (pan.state == UIGestureRecognizerStateEnded) {
            self.nc.xa_Transitioning = NO;
        }
    }
}

- (void)xa_handleNavigationTransition:(UIGestureRecognizer *)gr{
    [self xa_handleNavigationTransition:gr];
    if([gr isKindOfClass:[UIPanGestureRecognizer class]]){
        XABaseTransition * transition = [XATransitionManager sharedManager].transition;
        [transition interactiveTransitioningEvent:(UIPanGestureRecognizer *)gr];
    }
}

#pragma mark - Deal
- (CGFloat)calcTransitioningX:(CGPoint)translationPoint{
    CGFloat translationX = translationPoint.x > 0 ? 0 : translationPoint.x;
    return translationX;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer == self.pushInteractivePan){
        CGPoint point    = [gestureRecognizer translationInView:nil];
        CGPoint velocity = [gestureRecognizer velocityInView:nil];
        
        if (fabs(velocity.y) > fabs(velocity.x)) {//垂直方向不处理
            return NO;
        }
        
        if(point.x > 0){ //向右边滑动不处理
            return NO;
        }
        
        self.nextVC = [self.transitionDelegate xa_nextViewControllerInTransitionMode:self.transitionMode];//是否为有效的控制器
        if(self.nextVC  == nil ||
           [self.nc.childViewControllers containsObject:self.nextVC]){
            return NO;
        }
        
        return YES;
    }else if(gestureRecognizer == self.popInteractivePan){
        UIPanGestureRecognizer * panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point     = [panGestureRecognizer translationInView:nil];
        CGPoint velocity  = [panGestureRecognizer velocityInView:nil];
        
        if (fabs(velocity.y) > fabs(velocity.x)) {//垂直方向不处理
            return NO;
        }
        
        if(point.x < 0){ //向左边滑动不处理
            return NO;
        }
        
        if(self.nc.viewControllers.count <= 1){//栈底控制器不需要
            return NO;
        }
        
        return [self.nc xa_isPopEnable];//Pop功能开关
    }
    return NO;
}



#pragma mark - Getter/Setter
- (XATransitionMode)transitionMode{
    return XATransitionModeLeft;
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
 
    return nil;
}

- (UIPanGestureRecognizer *)popInteractivePan{
    if(_popInteractivePan == nil){
        //接管系统的pop手势,runtime拿到系统pop手势的target与action,借助其action完成左滑pop转场的功能。
        UIGestureRecognizer *systemPopGR = self.nc.interactivePopGestureRecognizer;
        id  target = [[systemPopGR valueForKey:@"_targets"]firstObject];
        id  transitionTarget   = [target valueForKey:@"_target"];
        SEL transitionSEL      = NSSelectorFromString(@"handleNavigationTransition:");
        
        _popInteractivePan = [[UIPanGestureRecognizer alloc]initWithTarget:transitionTarget action:transitionSEL];
        [self.nc.view addGestureRecognizer:_popInteractivePan];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [XANavBarTransitionTool swizzlingMethodWithOrginClass:[target class] swizzledClass:[self class] originalSEL:transitionSEL swizzledSEL:@selector(xa_handleNavigationTransition:)];
        });
    }
    return _popInteractivePan;
}

@end
