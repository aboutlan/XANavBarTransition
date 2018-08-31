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
+ (XABaseTransition *)handlerWithNc:(UINavigationController *)nc
                     transitionType:(XATransitionType)type
                 transitionDelegate:(id<XATransitionDelegate>)delegate{
    
    if(nc == nil || delegate == nil){
        return nil;
    }
    
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
