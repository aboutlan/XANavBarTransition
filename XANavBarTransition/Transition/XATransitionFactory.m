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
+(XABaseTransition *)handlerWithType:(XATransitionType)type
                         msgDelegate:(id<XATransitionMessageDelegate>)delegate
                navigationController:(UINavigationController *)nc{
    
    if(nc == nil || delegate == nil){
        return nil;
    }
    
    XABaseTransition *transition = nil;
    switch (type) {
        case XATransitionTypeLeft:
            transition  = [[XALeftTransition alloc] initWithNavigationController:nc
                                                                        delegate:delegate];
            break;
        case XATransitionTypeRight:
            transition = [[XARightTransition alloc] initWithNavigationController:nc
                                                                        delegate:delegate];
        default:
            break;
    }
    return transition;
}
@end
