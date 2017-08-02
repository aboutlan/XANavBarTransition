//
//  UINavigationController+XANavBarTransition.h
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (XANavBarTransition)<UIGestureRecognizerDelegate>

/**
 当前手势是否正在滑动转场中
 */
@property(nonatomic,assign,getter=xa_isGrTransitioning)BOOL xa_grTransitioning;


- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha;


@end
