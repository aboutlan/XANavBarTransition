//
//  UIViewController+XANavBarTransition.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "UIViewController+XANavBarTransition.h"
#import "UINavigationController+XANavBarTransition.h"
#import "UIView+XATransitionExtension.h"
#import "XANavBarTransitionTool.h"
#import "XATransitionSession.h"
#import "XANavigationControllerObserver.h"
#import <objc/message.h>


@interface UIViewController ()

/**
 当前控制器的转场行为类型
 */
@property(nonatomic, assign, readonly)XATransitionAction xa_transitionAction;

/**
 当前控制器的转场会话对象
 */
@property(nonatomic, strong, readwrite)XATransitionSession *xa_transitionSession;

@end
@implementation UIViewController (XANavBarTransition)
#pragma mark - Setup
+ (void)load{
    SEL  originalDidLoadSEL = @selector(viewDidLoad);
    SEL  swizzledDidLoadSEL = @selector(xa_viewDidLoad);
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[self class] swizzledClass:[self class] originalSEL:originalDidLoadSEL swizzledSEL:swizzledDidLoadSEL];
    
    SEL  originalWillAppearSEL = @selector(viewWillAppear:);
    SEL  swizzledWillAppearSEL = @selector(xa_viewWillAppear:);
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[self class] swizzledClass:[self class] originalSEL:originalWillAppearSEL swizzledSEL:swizzledWillAppearSEL];
    
    SEL  originalDidAppearSEL = @selector(viewDidAppear:);
    SEL  swizzledDidAppearSEL = @selector(xa_viewDidAppear:);
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[self class] swizzledClass:[self class] originalSEL:originalDidAppearSEL swizzledSEL:swizzledDidAppearSEL];
    
    SEL  originalDidDisappearSEL = @selector(viewDidDisappear:);
    SEL  swizzledDidDisappearSEL = @selector(xa_viewDidDisappear:);
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[self class] swizzledClass:[self class] originalSEL:originalDidDisappearSEL swizzledSEL:swizzledDidDisappearSEL];
}

- (void)xa_viewDidLoad {
    //vc setup
    self.xa_navBarAlpha = 1;
    self.xa_isPopEnable = YES;
    if([self isKindOfClass: [UINavigationController class]]){//nc setup
        UINavigationController *nc = (UINavigationController *)self;
        nc.xa_isTransitionEnable = YES;
        nc.xa_ncObserver = [[XANavigationControllerObserver alloc]initWithNc:nc];
    }
    [self xa_viewDidLoad];
}

- (void)xa_viewWillAppear:(BOOL)animated{
    [self xa_viewWillAppear:YES];

    
    [self xa_dealViewWillAppear];
}

- (void)xa_viewDidAppear:(BOOL)animated{
    [self xa_viewDidAppear:YES];
   
    [self xa_dealViewDidAppear];
}

- (void)xa_viewDidDisappear:(BOOL)animated{
    [self xa_viewDidDisappear:YES];
    
    [self xa_dealViewDidDisappear];
}

#pragma mark - Deal
- (void)xa_dealViewWillAppear{
    if(self.navigationController == nil ||
       self.navigationController.xa_isTransitioning == YES ||//转场中不允许设置导航栏透明度,防止导航栏背景跳变
       [self.view xa_isDisplaying] == NO){
        return;
    }
    
    //更新当前控制器的导航栏透明度
    [self.navigationController xa_changeNavBarAlpha:self.xa_navBarAlpha];
}

- (void)xa_dealViewDidAppear{
    if(self.navigationController == nil ||
       self.navigationController.xa_isTransitioning == YES ||
       self.navigationController.topViewController != self ||
       [self.view xa_isDisplaying] == NO){
        return;
    }
    //初始化当前控制器转场信息
    self.xa_transitionSession = [[XATransitionSession alloc] initSessionWithNc:self.navigationController
                                                                transitionMode:self.xa_transitionMode
                                                              transitionAction:self.xa_transitionAction
                                                            transitionDelegate:self.xa_transitionDelegate];
}

- (void)xa_dealViewDidDisappear{
    if(self.xa_transitionSession == nil){
        return;
    }
    //销毁当前控制器转场信息
    [self.xa_transitionSession unInitSessionWithVC:self];
    self.xa_transitionSession = nil;
}

#pragma mark - Getter/Setter

- (BOOL)xa_isPopEnable{
    return [objc_getAssociatedObject(self, _cmd)boolValue] ;
}

- (void)setXa_isPopEnable:(BOOL)xa_isPopEnable{
    objc_setAssociatedObject(self, @selector(xa_isPopEnable), @(xa_isPopEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)xa_navBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}

- (void)setXa_navBarAlpha:(CGFloat)xa_navBarAlpha{
    xa_navBarAlpha = MAX(0,MIN(1, xa_navBarAlpha));
    objc_setAssociatedObject(self, @selector(xa_navBarAlpha), @(xa_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self.navigationController xa_changeNavBarAlpha:xa_navBarAlpha];
}

- (XATransitionMode)xa_transitionMode{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setXa_transitionMode:(XATransitionMode)xa_transitionMode{
    objc_setAssociatedObject(self, @selector(xa_transitionMode), @(xa_transitionMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<XATransitionDelegate>)xa_transitionDelegate{
    return objc_getAssociatedObject(self, _cmd) ;
}

- (void)setXa_transitionDelegate:(id<XATransitionDelegate>)xa_transitionDelegate{
    objc_setAssociatedObject(self,@selector(xa_transitionDelegate),xa_transitionDelegate,OBJC_ASSOCIATION_ASSIGN);
}


- (BOOL)xa_isSetTansition{
     return [objc_getAssociatedObject(self, _cmd)boolValue];
}

- (void)setXa_isSetTansition:(BOOL)xa_isSetTansition{
     objc_setAssociatedObject(self, @selector(xa_isSetTansition), @(xa_isSetTansition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XATransitionSession *)xa_transitionSession{
     return objc_getAssociatedObject(self, _cmd);
}

- (void)setXa_transitionSession:(XATransitionSession *)xa_transitionSession{
    
    objc_setAssociatedObject(self, @selector(xa_transitionSession), xa_transitionSession, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XATransitionAction)xa_transitionAction{

    XATransitionAction action = XATransitionActionOnlyPop;
    if(self.xa_transitionDelegate == nil && self.xa_isPopEnable == NO){
        
        action = XATransitionActionNerver;
        
    }else if(self.xa_transitionDelegate != nil && self.xa_isPopEnable == NO){
        
        action =  XATransitionActionOnlyPush;
        
    }else if(self.xa_transitionDelegate == nil && self.xa_isPopEnable == YES){
        
        action =  XATransitionActionOnlyPop;
        
    }else{
        action = XATransitionActionPushPop;
        
    }
    return action;
}


@end
