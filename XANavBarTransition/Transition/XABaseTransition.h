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
@property (nonatomic, strong) XABaseTransitionAnimation *animation;
@property (nonatomic, strong) UIPanGestureRecognizer *interactivePan;
@property (nonatomic, assign) TransitionType transitionType;


- (instancetype)initWithNavigationController:(UINavigationController *)nc;

- (CGFloat)calcTransitioningProgress:(CGPoint)translationPoint;
@end
