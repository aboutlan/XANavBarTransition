//
//  UINavigationController+XANavBarTransition.h
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (XANavBarTransition)

/**
 当前是否正在手势滑动转场中
 */
@property(nonatomic,assign,getter=xa_isTransitioning)BOOL xa_transitioning;


- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;


@end
