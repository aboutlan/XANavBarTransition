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

@interface UIViewController ()

/**
 当前控制器是否设置过导航栏透明度
 */
@property(nonatomic,assign)BOOL xa_isSetBarAlpha;

/**
 当前控制器是否设置过转场信息
 */
@property(nonatomic,assign)BOOL xa_isSetTansition;
@end
@implementation UIViewController (XANavBarTransition)
+ (void)load{
    
    SEL  originalWillAppearSEL = @selector(viewWillAppear:);
    SEL  swizzledWillAppearSEL = @selector(xa_viewWillAppear:);
    [self swizzlingMethodWithOriginal:originalWillAppearSEL swizzled:swizzledWillAppearSEL];
    
    SEL  originalDidAppearSEL = @selector(viewDidAppear:);
    SEL  swizzledDidAppearSEL = @selector(xa_viewDidAppear:);
    [self swizzlingMethodWithOriginal:originalDidAppearSEL swizzled:swizzledDidAppearSEL];
    
    SEL  originalDidDisappearSEL = @selector(viewDidDisappear:);
    SEL  swizzledDidDisappearSEL = @selector(xa_viewDidDisappear:);
    [self swizzlingMethodWithOriginal:originalDidDisappearSEL swizzled:swizzledDidDisappearSEL];
   
}

+ (void)swizzlingMethodWithOriginal:(SEL)originalSEL swizzled:(SEL)swizzledSEL{

    Method orginMethod   = class_getInstanceMethod(self, originalSEL);
    Method swizzldMethod = class_getInstanceMethod(self, swizzledSEL);
    IMP originalIMP = method_getImplementation(orginMethod);
    IMP swizzldIMP  = method_getImplementation(swizzldMethod);
    const char *originalType = method_getTypeEncoding(orginMethod);
    const char *swizzldType  = method_getTypeEncoding(swizzldMethod);
    class_replaceMethod(self, swizzledSEL, originalIMP, originalType);
    class_replaceMethod(self, originalSEL, swizzldIMP, swizzldType);
}

#pragma mark - Action
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
       self.navigationController.xa_isTransitioning){
        return;
    }
    if([self xa_isSetBarAlpha] &&
       [self.view xa_isDisplaying]){
        //更新当前控制器的导航栏透明度
        [self.navigationController xa_changeNavBarAlpha:self.xa_navBarAlpha];
    }else{
        //设置导航栏透明度默认值
        self.xa_navBarAlpha = 1;
    }
}

- (void)xa_dealViewDidAppear{
    if(self.navigationController == nil){
        return;
    }
    if([self xa_isSetTansition] &&
       [self.view xa_isDisplaying]){
        //配置当前控制器转场信息
        [self.navigationController xa_configTransitionInfoWithType:self.xa_transitionType
                                                          delegate:self.xa_transitionDelegate];
    }
}

- (void)xa_dealViewDidDisappear{
    if([self xa_isSetTansition] &&
       [self.view xa_isDisplaying]){
        //清除当前控制器转场信息
        [self.navigationController xa_unInitTransitionInfo];
    }
}

#pragma mark - Getter/Setter
- (CGFloat)xa_navBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}

- (void)setXa_navBarAlpha:(CGFloat)xa_navBarAlpha{
    xa_navBarAlpha = MAX(0,MIN(1, xa_navBarAlpha));
    self.xa_isSetBarAlpha = YES;
    objc_setAssociatedObject(self, @selector(xa_navBarAlpha), @(xa_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController xa_changeNavBarAlpha:xa_navBarAlpha];
}

- (XATransitionType)xa_transitionType{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setXa_transitionType:(XATransitionType)xa_transitionType{
    self.xa_isSetTansition = xa_transitionType != XATransitionTypeUnknow;
    objc_setAssociatedObject(self, @selector(xa_transitionType), @(xa_transitionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<XATransitionDelegate>)xa_transitionDelegate{
    return objc_getAssociatedObject(self, _cmd) ;
}

- (void)setXa_transitionDelegate:(id<XATransitionDelegate>)xa_transitionDelegate{
    objc_setAssociatedObject(self,@selector(xa_transitionDelegate),xa_transitionDelegate,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xa_isSetBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)boolValue];
}

- (void)setXa_isSetBarAlpha:(BOOL)xa_isSetBarAlpha{
    objc_setAssociatedObject(self, @selector(xa_isSetBarAlpha), @(xa_isSetBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)xa_isSetTansition{
     return [objc_getAssociatedObject(self, _cmd)boolValue];
    
}

- (void)setXa_isSetTansition:(BOOL)xa_isSetTansition{
    
     objc_setAssociatedObject(self, @selector(xa_isSetTansition), @(xa_isSetTansition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
