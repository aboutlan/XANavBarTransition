//
//  XANavBarTransitionConst.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XATransitionMode) {
    XATransitionModeLeft = 0, //mode:left push，right pop
    XATransitionModeRight//mode:right push,left pop
};

typedef NS_ENUM(NSInteger, XATransitionAction) {
    XATransitionActionNerver = 0,
    XATransitionActionOnlyPush,
    XATransitionActionOnlyPop,
    XATransitionActionPushPop
};

UIKIT_EXTERN const NSInteger  XATransitionAnimationMargin;
