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
@property (nonatomic, assign) BOOL xa_isTransitioning;

/**
 是否开启转场功能,该属性会作用于全局。
 */
@property (nonatomic, assign) BOOL xa_isTransitionEnable;

/**
 改变当前导航栏的透明度
 
 @param navBarAlpha 透明度
 */
- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;
@end
