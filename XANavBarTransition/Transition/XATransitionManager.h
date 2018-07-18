//
//  XATransitionManager.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"
#import "UINavigationController+XANavBarTransition.h"

@interface XATransitionManager : NSObject

@property (nonatomic, assign, readonly) XATransitionType transitionType;
@property (nonatomic, weak,   readonly) id<XATransitionDelegate> transitionDelegate;

+ (instancetype)sharedManager;

- (void)configTransitionWithNc:(UINavigationController *)nc
                transitionType:(XATransitionType)transitionType
            transitionDelegate:(id<XATransitionDelegate>)transitionDelegate;
@end
