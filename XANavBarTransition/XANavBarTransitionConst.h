//
//  XANavBarTransitionConst.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XATransitionMode) {
    XATransitionModeUnknow = 0,
    XATransitionModeLeft,
    XATransitionModeRight
};

typedef NS_ENUM(NSInteger, XATransitionAction) {
    XATransitionActionNerver = 0,
    XATransitionActionOnlyPush,
    XATransitionActionOnlyPop,
    XATransitionActionPushPop
};
