//
//  XANavigationControllerObserver.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/9/9.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XABaseTransition;
@interface XANavigationControllerObserver : NSObject<UINavigationControllerDelegate>
@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property (nonatomic, weak, readonly) XABaseTransition *transition;
@property (nonatomic, weak, readonly) UINavigationController *nc;

- (instancetype)initWithNc:(UINavigationController *)nc;

- (void)configWithTransition:(XABaseTransition *)transition;

- (void)cleanConfig;
@end
