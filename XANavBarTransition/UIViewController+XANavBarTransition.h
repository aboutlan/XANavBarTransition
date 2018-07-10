//
//  UIViewController+XANavBarTransition.h
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"
@protocol XATransitionDelegate <NSObject>
- (UIViewController *)xa_slideToNextViewController:(XATransitionType)transitionType;

@end

@interface UIViewController (XANavBarTransition)
/**
 当前控制器导航栏的透明度
 */
@property(nonatomic,assign)CGFloat xa_navBarAlpha;

/**
 转场类型
 */
@property (nonatomic, assign) XATransitionType xa_transitionType;

/**
 转场代理
 */
@property (nonatomic,weak) id <XATransitionDelegate>  xa_transitionDelegate;

/**
 当前控制器是否设置过导航栏透明度
 */
@property(nonatomic,assign)BOOL xa_isSetBarAlpha;
@end
