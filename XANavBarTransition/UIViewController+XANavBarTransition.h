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
- (UIViewController *)xa_nextViewControllerInTransitionType:(XATransitionType)transitionType;

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
 配置当前控制器转场信息

 @param transitionType 转场类型
 @param transitionDelegate 转场代理
 */
//- (void)configTransitionWithType:(XATransitionType)transitionType
//                        delegate:(id <XATransitionDelegate>)transitionDelegate;

@end
