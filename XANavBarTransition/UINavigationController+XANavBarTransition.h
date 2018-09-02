//
//  UINavigationController+XANavBarTransition.h
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"

@protocol XATransitionDelegate;
@interface UINavigationController (XANavBarTransition)<UIGestureRecognizerDelegate>

/**
 当前是否正在滑动转场中
 */
@property (nonatomic, assign, getter=xa_isTransitioning) BOOL xa_Transitioning;

/**
 是否开启转场功能
 */
@property (nonatomic, assign, getter=xa_isTransitionEnable) BOOL xa_TransitionEnable;

/**
 改变当前导航栏的透明度
 
 @param navBarAlpha 透明度
 */
- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;

/**
  配置转场的信息

 @param transitionMode 转场类型
 @param transitionAction 转场行为
 @param transitionDelegate 转场代理
 */
- (void)xa_configTransitionInfoWithMode:(XATransitionMode)transitionMode
                                 action:(XATransitionAction)transitionAction
                               delegate:(id <XATransitionDelegate>)transitionDelegate;

/**
 清除转场的信息
 */
- (void)xa_unInitTransitionInfo;
@end
