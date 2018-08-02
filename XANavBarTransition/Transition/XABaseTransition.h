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
@class XABaseTransition;
@protocol XATransitionMessageDelegate <NSObject>
- (void)transition:(XABaseTransition *)transition startTransitionAction:(XATransitionType )transitionType;
- (void)transition:(XABaseTransition *)transition endTransitionAction:(BOOL)isFinishTransition;
@required
- (UIViewController *)transition:(XABaseTransition *)transition getNextViewControllerAction:(XATransitionType )transitionType;
@end
@interface XABaseTransition : NSObject<UIGestureRecognizerDelegate>{
    @protected
    XABaseTransitionAnimation *_animation;
}
@property (nonatomic, weak)   UINavigationController *nc;
@property (nonatomic, weak)   id<XATransitionMessageDelegate> delegate;
@property (nonatomic, assign) BOOL transitionEnable;
@property (nonatomic, strong) UIViewController *nextVC;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactive;
@property (nonatomic, strong, readonly) XABaseTransitionAnimation *pushAnimation;
@property (nonatomic, strong, readonly) XABaseTransitionAnimation *popAnimation;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *interactivePan;
@property (nonatomic, assign, readonly) XATransitionType transitionType;

- (instancetype)initWithNavigationController:(UINavigationController *)nc
                                    delegate:(id<XATransitionMessageDelegate>)delegate;

#pragma mark - Subclass Rewrite
- (void)setupWithNc:(UINavigationController *)nc
        delegate:(id<XATransitionMessageDelegate>)delegate;
- (CGFloat)calcTransitioningX:(CGPoint)translationPoint;
@end

