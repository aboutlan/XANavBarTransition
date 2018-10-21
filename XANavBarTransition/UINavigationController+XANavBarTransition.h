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
@class XANavigationControllerObserver;
@interface UINavigationController (XANavBarTransition)<UIGestureRecognizerDelegate>

/**
 当前是否正在滑动转场中
 */
@property (nonatomic, assign) BOOL xa_isTransitioning;

/**
 当前导航控制器下所有控制器是否开启转场功能。
 */
@property (nonatomic, assign) BOOL xa_isTransitionEnable;


/**
 当前导航控制器的代理对象
 */
@property (nonatomic, strong) XANavigationControllerObserver  *xa_ncObserver;

/**
 改变当前导航栏的透明度
 
 @param navBarAlpha 透明度
 */
- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;

/**
 当前导航控制器的代理属性
 该代理属性用于替代原来协议为<UINavigationControllerDelegate>的代理属性。由于内部已经占用了UINavigationControllerDelegate代理并且进行回调监听,如果程序当中需要监听UINavigationControllerDelegate的事件回调,请将代理对象设置到该代理属性上并实现对应的代理方法。
 */
@property (nonatomic,weak) id<UINavigationControllerDelegate>  xa_delegate;

@end
