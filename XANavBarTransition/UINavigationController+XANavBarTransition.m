//
//  UINavigationController+XANavBarTransition.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "UINavigationController+XANavBarTransition.h"
#import "UIViewController+XANavBarTransition.h"
#import <objc/message.h>

@implementation UINavigationController (XANavBarTransition)
+ (void)load{
    //交换导航控制器的手势进度转场方法,来监听手势滑动的进度
    SEL originalSEL =  NSSelectorFromString(@"_updateInteractiveTransition:");
    SEL swizzledSEL =  NSSelectorFromString(@"xa_updateInteractiveTransition:");
    [UINavigationController swizzlingMethodWithOriginal:originalSEL swizzled:swizzledSEL];
    
    
    //交换导航控制器的popViewControllerAnimated:方法,来监听什么时候当前控制被back
    SEL popOriginalSEL =  @selector(popViewControllerAnimated:);
    SEL popSwizzledSEL =  NSSelectorFromString(@"xa_popViewControllerAnimated:");
    [UINavigationController swizzlingMethodWithOriginal:popOriginalSEL swizzled:popSwizzledSEL];
    
}


#pragma mark - Action
+ (void)swizzlingMethodWithOriginal:(SEL)originalSEL swizzled:(SEL)swizzledSEL{
    
    Method orginMethod   = class_getInstanceMethod(self, originalSEL);
    Method swizzldMethod = class_getInstanceMethod(self, swizzledSEL);
    BOOL addSuccess = class_addMethod(self , originalSEL, method_getImplementation(swizzldMethod), method_getTypeEncoding(swizzldMethod));
    if(addSuccess){
        class_replaceMethod(self , swizzledSEL, method_getImplementation(orginMethod), method_getTypeEncoding(orginMethod));
        
    }else{
        method_exchangeImplementations(orginMethod, swizzldMethod);
    }
}

- (void)setup{
    //接管系统的边缘手势滑动的代理
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    self.xa_grTransitioning = YES;
    return YES;
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

#pragma mark  - Transition
- (void)xa_updateInteractiveTransition:(CGFloat)percentComplete{
    [self xa_updateInteractiveTransition:percentComplete];
    UIViewController *topVC = self.topViewController;
    if(topVC){
        //通过transitionCoordinator拿到转场的两个控制器上下文信息
        id <UIViewControllerTransitionCoordinator> coordinator =  topVC.transitionCoordinator;
        if(coordinator != nil){
            //拿到源控制器和目的控制器的透明度(每个控制器都单独保存了一份)
            CGFloat fromVCAlpha  = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey].xa_navBarAlpha;
            CGFloat toVCAlpha    = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey].xa_navBarAlpha;
            //再通过源,目的控制器的导航条透明度和转场的进度(percentComplete)计算转场时导航条的透明度
            CGFloat newAlpha     = fromVCAlpha + ((toVCAlpha - fromVCAlpha ) * percentComplete);
            //这里不要直接去修改控制器navBarAlpha属性,会影响目的控制器的navBarAlpha的数值
            [self xa_changeNavBarAlpha:newAlpha];
        }
    }
}


- (UIViewController *)xa_popViewControllerAnimated:(BOOL)animated{
    UIViewController *popVc =  [self xa_popViewControllerAnimated:animated];
    if(self.viewControllers.count <= 0){
        return popVc;
    }
    UIViewController *topVC = [self.viewControllers lastObject];
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        
        //监听手势返回的交互改变,如手势滑动过程当中松手就会回调block
        if (coordinator != nil) {
            if([[UIDevice currentDevice].systemVersion intValue]  >= 10){//适配iOS10
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    [self dealNavBarChangeAction:context];
                }];
            }else{
                [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self dealNavBarChangeAction:context];
                }];
            }
        }
    }
    return popVc;
}


- (void)dealNavBarChangeAction:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 取消了(还在当前页面)
        //根据剩余的进度来计算动画时长xa_changeNavBarAlpha
        CGFloat animdDuration = [context transitionDuration] * [context percentComplete];
        CGFloat fromVCAlpha   = [context viewControllerForKey:UITransitionContextFromViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [self xa_changeNavBarAlpha:fromVCAlpha];
        }];
        
    } else {// 自动完成(pop到上一个界面了)
        
        CGFloat animdDuration = [context transitionDuration] * (1 -  [context percentComplete]);
        CGFloat toVCAlpha     = [context viewControllerForKey:UITransitionContextToViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [self xa_changeNavBarAlpha:toVCAlpha];
        }];
    };
    self.xa_grTransitioning = NO;
}


#pragma mark - Getter/Setter
- (BOOL)xa_isGrTransitioning{
    return [objc_getAssociatedObject(self, _cmd)boolValue];
    
}

- (void)setXa_grTransitioning:(BOOL)xa_grTransitioning{
    objc_setAssociatedObject(self, @selector(xa_isGrTransitioning), @(xa_grTransitioning), OBJC_ASSOCIATION_ASSIGN);
}


@end
