//
//  XATransitionFactory.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XATransitionFactory.h"
#import "XALeftTransition.h"
#import "XARightTransition.h"
@implementation XATransitionFactory


+ (XABaseTransition *)handlerWithType:(TransitionType)type
                 navigationController:(UINavigationController *)nc{
    XABaseTransition *transition = nil;
    switch (type) {
        case TransitionTypeLeft:
            transition  = [[XALeftTransition alloc] initWithNavigationController:nc];
            break;
        case TransitionTypeRight:
             transition = [[XARightTransition alloc] initWithNavigationController:nc];
        default:
            break;
    }
    return transition;
}
@end
