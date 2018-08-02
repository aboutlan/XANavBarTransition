//
//  XATransitionFactory.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XABaseTransition.h"
#import "XANavBarTransitionConst.h"

@interface XATransitionFactory : NSObject

+(XABaseTransition *)handlerWithType:(XATransitionType)type
                         msgDelegate:(id<XATransitionMessageDelegate>)delegate
                navigationController:(UINavigationController *)nc;

@end
