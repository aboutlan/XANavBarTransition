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
#import "XABaseTransition.h"
@implementation XATransitionFactory
+ (XABaseTransition *)handlerWithNc:(UINavigationController *)nc
                     transitionMode:(XATransitionMode)mode
                   transitionAction:(XATransitionAction)action
                 transitionDelegate:(id<XATransitionDelegate>)delegate{
    
    if(nc == nil){
        return nil;
    }
    
    XABaseTransition *transition = nil;
    switch (mode) {
        case XATransitionModeLeft:
            transition  = [[XALeftTransition alloc] initWithNavigationController:nc
                                                                transitionAction:action
                                                              transitionDelegate:delegate];
            break;
        case XATransitionModeRight:
            transition = [[XARightTransition alloc] initWithNavigationController:nc
                                                                transitionAction:action
                                                              transitionDelegate:delegate];
        default:
            break;
    }
    return transition;
}
@end
