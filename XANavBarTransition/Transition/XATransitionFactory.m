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
+ (XABaseTransition *)handlerWithType:(XATransitionType)type
                 navigationController:(UINavigationController *)nc
                   transitionDelegate:(id<XATransitionDelegate>)delegate{
    XABaseTransition *transition = nil;
    switch (type) {
        case XATransitionTypeLeft:
            transition  = [[XALeftTransition alloc] initWithNavigationController:nc
                                                              transitionDelegate:delegate];
            break;
        case XATransitionTypeRight:
             transition = [[XARightTransition alloc] initWithNavigationController:nc
                                                               transitionDelegate:delegate];
        default:
            break;
    }
    return transition;
}
@end
