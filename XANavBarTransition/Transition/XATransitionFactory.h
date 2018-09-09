//
//  XATransitionFactory.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XANavBarTransitionConst.h"
@class XABaseTransition;
@protocol XATransitionDelegate;
@interface XATransitionFactory : NSObject
+ (XABaseTransition *)handlerWithNc:(UINavigationController *)nc
                     transitionMode:(XATransitionMode)mode
                   transitionAction:(XATransitionAction)action
                 transitionDelegate:(id<XATransitionDelegate>)delegate;
@end
