//
//  UIViewController+XANavBarTransition.h
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"
@class XATransitionSession;
@protocol XATransitionDelegate <NSObject>
- (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode;
@end

@interface UIViewController (XANavBarTransition)
/**
 当前控制器导航栏的透明度，默认值为1
 */
@property(nonatomic,assign)CGFloat xa_navBarAlpha;

/**
 当前控制器是否允许使用手势驱动进行popViewController操作
 */
@property (nonatomic, assign) BOOL xa_isPopEnable;

/**
 当前控制器要转场类型，默认值XATransitionModeLeft
 */
@property (nonatomic, assign) XATransitionMode xa_transitionMode;

/**
 当前控制器转场代理
 */
@property (nonatomic,weak) id <XATransitionDelegate>  xa_transitionDelegate;

/**
 当前控制器的转场会话对象
 */
@property(nonatomic, strong, readonly)XATransitionSession *xa_transitionSession;
@end
