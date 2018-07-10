//
//  XABaseTransition.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XABaseTransitionAnimation.h"
#import "UIViewController+XANavBarTransition.h"
@interface XABaseTransition : NSObject<UIGestureRecognizerDelegate>{
    @protected
    XABaseTransitionAnimation *_animation;
}
@property (nonatomic, weak)   UINavigationController *nc;
@property (nonatomic, weak)   id<XATransitionDelegate> transitionDelegate;
@property (nonatomic, assign) BOOL transitionEnable;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactive;
@property (nonatomic, strong, readonly) XABaseTransitionAnimation *animation;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *interactivePan;
@property (nonatomic, assign, readonly) XATransitionType transitionType;

- (instancetype)initWithNavigationController:(UINavigationController *)nc
                          transitionDelegate:(id<XATransitionDelegate>)delegate;

#pragma mark - Subclass Rewrite
- (void)setupWithNc:(UINavigationController *)nc
           delegate:(id<XATransitionDelegate>)delegate;
- (CGFloat)calcTransitioningX:(CGPoint)translationPoint;
@end

