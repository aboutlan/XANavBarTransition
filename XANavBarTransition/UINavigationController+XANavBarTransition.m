//
//  UINavigationController+XANavBarTransition.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "UINavigationController+XANavBarTransition.h"
#import "UIViewController+XANavBarTransition.h"
#import "XATransitionManager.h"
#import <objc/message.h>

@implementation UINavigationController (XANavBarTransition)
#pragma mark - Setup
+ (void)load{
    
    SEL  originalDidLoadSEL = @selector(viewDidLoad);
    SEL  swizzledDidLoadSEL = @selector(xa_viewDidLoad);
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[self class] swizzledClass:[self class] originalSEL:originalDidLoadSEL swizzledSEL:swizzledDidLoadSEL];
}

- (void)xa_viewDidLoad {
    self.xa_TransitionEnable = YES;
    [self xa_viewDidLoad];
}

#pragma mark - Transition
- (void)xa_configTransitionInfoWithMode:(XATransitionMode)transitionMode
                                 action:(XATransitionAction)transitionAction
                               delegate:(id <XATransitionDelegate>)transitionDelegate{
    [XATransitionManager.sharedManager configTransitionWithNc:self
                                               transitionMode:transitionMode
                                             transitionAction:transitionAction
                                           transitionDelegate:transitionDelegate];
}

- (void)xa_unInitTransitionInfo{
    [XATransitionManager.sharedManager unInitTransitionWithNc:self];
}

#pragma mark - Alpha
- (void)xa_changeNavBarAlpha:(CGFloat)navBarAlpha{
    
    NSMutableArray *barSubviews = [NSMutableArray array];
    //将导航栏的子控件添加到数组当中,取首个子控件设置透明度(防止导航栏上存在非导航栏自带的控件)
    for (UIView * view in self.navigationBar.subviews) {
        if(![view isMemberOfClass:[UIView class]]){
            [barSubviews addObject:view];
        }
    }
    Ivar  backgroundOpacityVar =  class_getInstanceVariable([UINavigationBar class], "__backgroundOpacity");
    if(backgroundOpacityVar){
         [self.navigationBar setValue:@(navBarAlpha) forKey:@"__backgroundOpacity"];
    }
    UIView *barBackgroundView  = [barSubviews firstObject];
    barBackgroundView.alpha    = navBarAlpha;
}

#pragma mark - Getter/Setter
- (BOOL)xa_isTransitioning{
    return [objc_getAssociatedObject(self, _cmd)boolValue];
}

- (void)setXa_Transitioning:(BOOL)xa_Transitioning{
    objc_setAssociatedObject(self, @selector(xa_isTransitioning), @(xa_Transitioning), OBJC_ASSOCIATION_RETAIN);
}


- (void)setXa_TransitionEnable:(BOOL)xa_TransitionEnable{
    objc_setAssociatedObject(self, @selector(xa_isTransitionEnable), @(xa_TransitionEnable), OBJC_ASSOCIATION_RETAIN);
    XATransitionManager.sharedManager.transitionEnable = xa_TransitionEnable;
}

- (BOOL)xa_isTransitionEnable{
    return [objc_getAssociatedObject(self, _cmd)boolValue];;
}

@end
