//
//  UINavigationController+XANavBarTransition.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "UINavigationController+XANavBarTransition.h"
#import "UIViewController+XANavBarTransition.h"
#import "XATransitionSession.h"
#import "XANavBarTransitionTool.h"
#import "XANavigationControllerObserver.h"
#import <objc/message.h>
@implementation UINavigationController (XANavBarTransition)

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

- (void)setXa_isTransitioning:(BOOL)xa_isTransitioning{
      objc_setAssociatedObject(self, @selector(xa_isTransitioning), @(xa_isTransitioning), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)xa_isTransitionEnable{
     return [objc_getAssociatedObject(self, _cmd)boolValue];;
}

- (void)setXa_isTransitionEnable:(BOOL)xa_isTransitionEnable{
    objc_setAssociatedObject(self, @selector(xa_isTransitionEnable), @(xa_isTransitionEnable), OBJC_ASSOCIATION_RETAIN);
    self.topViewController.xa_transitionSession.transitionEnable = xa_isTransitionEnable;
}

- (XANavigationControllerObserver *)xa_ncObserver{
     return objc_getAssociatedObject(self, _cmd) ;
}

- (void)setXa_ncObserver:(XANavigationControllerObserver *)xa_ncObserver{
       objc_setAssociatedObject(self,@selector(xa_ncObserver),xa_ncObserver,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UINavigationControllerDelegate>)xa_delegate{
    return self.xa_ncObserver.delegate;
}

- (void)setXa_delegate:(id<UINavigationControllerDelegate>)xa_delegate{
    self.xa_ncObserver.delegate = xa_delegate;
}

@end
