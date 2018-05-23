//
//  XABaseTransition.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XABaseTransitionAnimation.h"
#import "UINavigationController+XANavBarTransition.h"
@interface XABaseTransition : NSObject<UIGestureRecognizerDelegate>{
    @protected
    XABaseTransitionAnimation *_animation;
}
@property (nonatomic, assign) BOOL transitionEnable;

@property (nonatomic, weak)   UINavigationController *nc;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactive;
@property (nonatomic, strong, readonly) XABaseTransitionAnimation *animation;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *interactivePan;
@property (nonatomic, assign, readonly) TransitionType transitionType;

- (instancetype)initWithNavigationController:(UINavigationController *)nc;

- (CGFloat)calcTransitioningX:(CGPoint)translationPoint;
@end
