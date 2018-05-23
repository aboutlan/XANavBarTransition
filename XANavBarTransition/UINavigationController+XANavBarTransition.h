//
//  UINavigationController+XANavBarTransition.h
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"

@protocol XANavBarTransitionDelegate <NSObject>
- (UIViewController *)xa_slideToNextViewController:(UINavigationController *)nc
                      transitionType:(TransitionType)transitionType;


@end

@interface UINavigationController (XANavBarTransition)<UIGestureRecognizerDelegate>

/**
 转场类型
 */
@property (nonatomic, assign) TransitionType xa_transitionType;

/**
 当前手势是否正在滑动转场中
 */
@property (nonatomic, assign, getter=xa_isGrTransitioning) BOOL xa_grTransitioning;

/**
 转场代理
 */
@property (nonatomic,weak) id <XANavBarTransitionDelegate>  xa_transitionDelegate;

/**
 改变当前导航栏的透明度

 @param navBarAlpha 透明度
 */
- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;


@end
