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

- (void)setup{
    [self configTransition];
}


#pragma mark - Transition
- (void)configTransition{
    //配置转场管理者
    [XATransitionManager.sharedManager configTransition:self];
}


- (void)xa_changeTransitionDelegate:(id <XATransitionDelegate>)xa_transitionDelegate{
    XATransitionManager.sharedManager.transitionDelegate = xa_transitionDelegate;
}


- (void)xa_changeTransitionType:(XATransitionType)xa_transitionType{
    XATransitionManager.sharedManager.transitionType = xa_transitionType;
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
    
    //做一些初始化操作
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setup];
    });
}


#pragma mark - Getter/Setter
- (BOOL)xa_isGrTransitioning{
    return [objc_getAssociatedObject(self, _cmd)boolValue];
}

- (void)setXa_grTransitioning:(BOOL)xa_grTransitioning{
    objc_setAssociatedObject(self, @selector(xa_isGrTransitioning), @(xa_grTransitioning), OBJC_ASSOCIATION_ASSIGN);
}

@end
