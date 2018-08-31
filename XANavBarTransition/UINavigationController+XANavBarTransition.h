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
 是否允许左滑Pop
 */
@property (nonatomic, assign, getter=xa_isPopEnable) BOOL xa_popEnable;

/**
 改变当前导航栏的透明度
 
 @param navBarAlpha 透明度
 */
- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;

/**
 改变当前的转场代理

 @param xa_transitionDelegate 转场代理
 */
//- (void)xa_changeTransitionDelegate:(id <XATransitionDelegate>)xa_transitionDelegate;

/**
 改变当前的转场类型

 @param xa_transitionMode  转场类型
 */
//- (void)xa_changetransitionMode:(XATransitionMode)xa_transitionMode;


/**
  配置转场的信息

 @param transitionMode 转场类型
 @param transitionDelegate 转场代理
 */
- (void)xa_configTransitionInfoWithMode:(XATransitionMode)transitionMode
                               delegate:(id <XATransitionDelegate>)transitionDelegate;

/**
 清除转场的信息
 */
- (void)xa_unInitTransitionInfo;
@end
