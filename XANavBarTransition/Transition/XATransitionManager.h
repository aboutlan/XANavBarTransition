//
//  XATransitionManager.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransitionConst.h"

@interface XATransitionManager : NSObject
@property (nonatomic, assign) TransitionType transitionType;

+ (instancetype)sharedManager;

- (void)configTransition:(UINavigationController *)nc;

@end
