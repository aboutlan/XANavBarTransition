//
//  XABaseTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XABaseTransition.h"
#import "UINavigationController+XANavBarTransition.h"
#import "XABaseTransition.h"
@interface XABaseTransition()<UIGestureRecognizerDelegate>
@property (nonatomic, weak)   UIView *transitionView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation XABaseTransition

- (instancetype)initWithNavigationController:(UINavigationController *)nc{
    if(self = [super init]){
        [self setup:nc];
    }
    return self;
}

#pragma mark - Setup
- (void)setup:(UINavigationController *)nc{
    self.nc = nc;
    self.transitionView = nc.view;
    [self setupGestureRecognize:nc.view];
}

- (void)setupGestureRecognize:(UIView *)transitionView{
    self.pan.enabled  = YES;
    self.pan.delegate = self;
    self.transitionEnable = self.pan.enabled;
    [transitionView addGestureRecognizer:self.pan];
}

#pragma mark - Action
- (void)interactiveTransitioningEvent:(UIPanGestureRecognizer *)pan{
    static NSTimeInterval beginTouchTime,endTouchTime;//beginTouchTime和endTouchTime这两个数据量主要是用于参考是否为轻扫
    CGPoint translation = [pan translationInView:self.transitionView];
    CGFloat x = translation.x > 0 ? 0 : translation.x;
    CGFloat distance = fabs(x / [UIScreen mainScreen].bounds.size.width) * 1.2;
    distance  = MIN(1, MAX(distance, 0));
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        beginTouchTime = [[NSDate date]timeIntervalSince1970];
        UIViewController *nextViewController =   [self.nc.xa_transitionDelegate xa_slideToNextViewController:self.nc transitionType:self.transitionType];
        [self.nc pushViewController:nextViewController animated:YES];
        [self.interactive updateInteractiveTransition:0];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        [self.interactive updateInteractiveTransition:distance];
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        endTouchTime = [[NSDate date]timeIntervalSince1970];
        CGFloat dValueTime = endTouchTime - beginTouchTime;
        if (distance > 0.3 || dValueTime <= 0.15f) {//dValueTime <= 0.15f 该条件用于判断是否为轻扫
            [self.interactive finishInteractiveTransition];
        } else {
            [self.interactive cancelInteractiveTransition];
        }
        self.interactive = nil;
    }
}


#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer == self.pan){
        CGPoint point    = [gestureRecognizer translationInView:nil];
        CGPoint velocity = [gestureRecognizer velocityInView:nil];
        
        if(!self.transitionEnable){
            return NO;
        }
        NSLog(@"x:%lf,y:%lf",velocity.x,velocity.y);
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
- (void)setTransitionEnable:(BOOL)transitionEnable{
    _transitionEnable = transitionEnable;
    self.pan.enabled  = transitionEnable;
    
    //如果关闭了全屏滑动,就开启系统的边缘滑动并接管代理
    //    BOOL interactivePopEnabled  =  !self.fullscreenPanGestureRecognizer.enabled;
    //需求,不开启侧滑
//    BOOL interactivePopEnabled = NO;
//    self.interactivePopGestureRecognizer.enabled  = interactivePopEnabled;
//    self.interactivePopGestureRecognizer.delegate = interactivePopEnabled ? self : self.interactivePopGestureRecognizerDelegate;
}

- (UIPercentDrivenInteractiveTransition *)interactive{
    if(_interactive == nil){
        _interactive = ({
            UIPercentDrivenInteractiveTransition *interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
            interactive.completionCurve = UIViewAnimationCurveEaseOut;
            interactive.completionSpeed = 0.99;
            interactive;
        });
    }
    return _interactive;
}

- (UIPanGestureRecognizer *)pan{
    if(_pan == nil){
        _pan = ({
            UIPanGestureRecognizer *pan  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveTransitioningEvent:)];
            pan;
        });
    }
    return _pan;
}

@end
