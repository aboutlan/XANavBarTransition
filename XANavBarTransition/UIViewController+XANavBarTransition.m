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
#import <objc/message.h>
#import "XANavBarTransition.h"
#import "XANavBarTransitionTool.h"


@interface UIViewController ()

/**
 当前控制器的转场行为类型
 */
@property(nonatomic, assign, readonly)XATransitionAction xa_transitionAction;

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
    self.xa_navBarAlpha = 1;
    
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
       self.navigationController.xa_isTransitioning){//转场中不允许设置导航栏透明度,防止导航栏背景跳变
        return;
    }
    if([self.view xa_isDisplaying]){
        //更新当前控制器的导航栏透明度
        [self.navigationController xa_changeNavBarAlpha:self.xa_navBarAlpha];
    }
}

- (void)xa_dealViewDidAppear{
    if(self.navigationController == nil){
        return;
    }
    if([self.view xa_isDisplaying]){
        //配置当前控制器转场信息
        [self.navigationController xa_configTransitionInfoWithMode:self.xa_transitionMode
                                                            action:self.xa_transitionAction
                                                          delegate:self.xa_transitionDelegate];
    }
}

- (void)xa_dealViewDidDisappear{
    if([self.view xa_isDisplaying]){
        //销毁当前控制器转场信息
        [self.navigationController xa_unInitTransitionInfo];
    }
}

#pragma mark - Getter/Setter
- (CGFloat)xa_navBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}

- (void)setXa_navBarAlpha:(CGFloat)xa_navBarAlpha{
    xa_navBarAlpha = MAX(0,MIN(1, xa_navBarAlpha));
    objc_setAssociatedObject(self, @selector(xa_navBarAlpha), @(xa_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController xa_changeNavBarAlpha:xa_navBarAlpha];
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

- (XATransitionAction)xa_transitionAction{
    BOOL isPop = YES;
    XATransitionAction action = XATransitionActionOnlyPop;
    if(self.xa_transitionDelegate == nil && isPop == NO){
        
        action = XATransitionActionNerver;
        
    }else if(self.xa_transitionDelegate != nil && isPop == NO){
        
        action =  XATransitionActionOnlyPush;
        
    }else if(self.xa_transitionDelegate == nil && isPop == YES){
        
        action =  XATransitionActionOnlyPop;
        
    }else{
        action = XATransitionActionPushPop;
    }
    return action;
}


@end
