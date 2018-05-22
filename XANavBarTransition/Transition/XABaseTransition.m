//
//  XABaseTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XABaseTransition.h"

@interface XABaseTransition()
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation XABaseTransition


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
@end
