//
//  XATransitionSession.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"
@class XABaseTransition;
@protocol XATransitionDelegate;
@interface XATransitionSession : NSObject
@property (nonatomic, assign) BOOL transitionEnable;
@property (nonatomic, strong, readonly) XABaseTransition *transition;
@property (nonatomic, assign, readonly) XATransitionMode transitionMode;
@property (nonatomic, weak,   readonly) UINavigationController  *nc;
@property (nonatomic, weak,   readonly) id<XATransitionDelegate> transitionDelegate;

- (instancetype)initSessionWithNc:(UINavigationController *)nc
                   transitionMode:(XATransitionMode)transitionMode
                 transitionAction:(XATransitionAction)transitionAction
               transitionDelegate:(id<XATransitionDelegate>)transitionDelegate;

- (void)unInitSessionWithVC:(UIViewController *)unInitVC;
@end
