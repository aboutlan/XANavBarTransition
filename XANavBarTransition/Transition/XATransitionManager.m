//
//  XATransitionManager.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XATransitionManager.h"
#import "XABaseTransition.h"
#import "XATransitionFactory.h"
#import "UIViewController+XANavBarTransition.h"
#import "UINavigationController+XANavBarTransition.h"
#import "SecondViewController.h"
#import <objc/message.h>
@interface XATransitionManager()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UINavigationController  *nc;
@property (nonatomic, assign) BOOL  hasConfigCompletion;
@property (nonatomic, strong) XABaseTransition *transition;
@end

@implementation XATransitionManager
#pragma mark - Setup
+ (void)load{
    //交换导航控制器的手势进度转场方法,来监听手势滑动的进度
    SEL originalSEL =  NSSelectorFromString(@"_updateInteractiveTransition:");
    SEL swizzledSEL =  NSSelectorFromString(@"xa_updateInteractiveTransition:");
    [self swizzlingMethodWithOriginal:originalSEL swizzled:swizzledSEL];
    
    //交换导航控制器的popViewControllerAnimated:方法,来监听什么时候当前控制被back
    SEL popOriginalSEL =  @selector(popViewControllerAnimated:);
    SEL popSwizzledSEL =  NSSelectorFromString(@"xa_popViewControllerAnimated:");
    [self swizzlingMethodWithOriginal:popOriginalSEL swizzled:popSwizzledSEL];
    
    SEL pushOriginalSEL =  @selector(pushViewController:animated:);
    SEL pushSwizzledSEL =  NSSelectorFromString(@"xa_pushViewController:animated:");
    [self swizzlingMethodWithOriginal:pushOriginalSEL swizzled:pushSwizzledSEL];
}

+ (instancetype)sharedManager{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Action

+ (void)swizzlingMethodWithOriginal:(SEL)originalSEL swizzled:(SEL)swizzledSEL{
    
    Class orginClass     = [UINavigationController class];
    Class swizzledClass  = [self class];
    Method orginMethod   = class_getInstanceMethod(orginClass, originalSEL);
    Method swizzldMethod = class_getInstanceMethod(swizzledClass, swizzledSEL);
    IMP originalIMP = method_getImplementation(orginMethod);
    IMP swizzldIMP  = method_getImplementation(swizzldMethod);
    const char *originalType = method_getTypeEncoding(orginMethod);
    const char *swizzldType  = method_getTypeEncoding(swizzldMethod);
    
    class_replaceMethod(orginClass, swizzledSEL, originalIMP, originalType);
    class_replaceMethod(orginClass, originalSEL, swizzldIMP, swizzldType);
    
}

- (void)configTransition:(UINavigationController *)nc{
    self.nc = nc;
    self.nc.delegate = self;
    self.nc.interactivePopGestureRecognizer.delegate = self;
//    self.transition  = [XATransitionFactory handlerWithType:self.transitionType
//                                       navigationController:self.nc
//                                         transitionDelegate:self.transitionDelegate];
}


- (void)xa_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self xa_pushViewController:viewController animated:animated];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    if (nc != nil &&
        viewController != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = viewController.transitionCoordinator;
        
        //监听手势返回的交互改变,如手势滑动过程当中松手就会回调block
        if (coordinator != nil) {
            if([[UIDevice currentDevice].systemVersion intValue]  >= 10){//适配iOS10
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    dealInteractionEndAction(context,nc);
                }];
            }else{
                [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    dealInteractionEndAction(context,nc);
                }];
            }
        }
    }
}


- (void)xa_updateInteractiveTransition:(CGFloat)percentComplete{
    [self xa_updateInteractiveTransition:percentComplete];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    UIViewController *topVC    = nc.topViewController;
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
            [nc xa_changeNavBarAlpha:newAlpha];
        }
    }
}


- (UIViewController *)xa_popViewControllerAnimated:(BOOL)animated{

    UIViewController *popVc    = [self xa_popViewControllerAnimated:animated];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    if(nc.viewControllers.count <= 0){
        return popVc;
    }
    UIViewController *topVC = [nc.viewControllers lastObject];
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        
        //监听手势返回的交互改变,如手势滑动过程当中松手就会回调block
        if (coordinator != nil) {
            if([[UIDevice currentDevice].systemVersion intValue]  >= 10){//适配iOS10
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    dealInteractionEndAction(context,nc);
                }];
            }else{
                [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    dealInteractionEndAction(context,nc);
                }];
            }
        }
    }
    return popVc;
}




#pragma mark - Deal
- (void)dealWillShowViewController:(UIViewController *)showVC{
    if([showVC.parentViewController isKindOfClass:[UINavigationController class]] &&
       (!showVC.navigationController.xa_isGrTransitioning)){
        //如果在控制器初始化的时候用户设置过导航栏的值,那么我们直接设置该导航栏应有的透明度值,没有设置过的话默认透明度给1
        if(showVC.xa_isSetBarAlpha){
            [showVC.navigationController xa_changeNavBarAlpha:showVC.xa_navBarAlpha];
        }else{
            showVC.xa_navBarAlpha = 1;
        }
    }
}


- (void)dealDidShowViewController:(UIViewController *)showVC{
    if([showVC.parentViewController isKindOfClass:[UINavigationController class]]){
        //每当页面显示的时候重置代理
        NSLog(@"showVC:%@,delegate:%@",showVC,showVC.xa_transitionDelegate);
        [showVC.navigationController xa_changeTransitionDelegate:showVC.xa_transitionDelegate];
    }
}

void dealInteractionEndAction(id<UIViewControllerTransitionCoordinatorContext> context,UINavigationController *nc){
    
    if ([context isCancelled]) {// 取消了(还在当前页面)
        //根据剩余的进度来计算动画时长xa_changeNavBarAlpha
        CGFloat animdDuration = [context transitionDuration] * [context percentComplete];
        CGFloat fromVCAlpha   = [context viewControllerForKey:UITransitionContextFromViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [nc xa_changeNavBarAlpha:fromVCAlpha];
        }completion:^(BOOL finished) {
            nc.xa_grTransitioning = NO;
        }];
        
    } else {// 自动完成(pop到上一个界面了)
        
        CGFloat animdDuration = [context transitionDuration] * (1 -  [context percentComplete]);
        CGFloat toVCAlpha     = [context viewControllerForKey:UITransitionContextToViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [nc xa_changeNavBarAlpha:toVCAlpha];
        }completion:^(BOOL finished) {
            nc.xa_grTransitioning = NO;
        }];
    };
}



#pragma mark - <UINavigationControllerDelegate>
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self dealWillShowViewController:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self dealDidShowViewController:viewController];
    //self.transition.transitionEnable = !(viewController == [self.nc.viewControllers firstObject]); //该控制器为根控制器,则不开启转场滑动功能
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    UIViewController *nextVc = [self.transitionDelegate xa_slideToNextViewController:self.transitionType];
    if(operation == UINavigationControllerOperationPush &&
       nextVc == toVC){
        return self.transition.animation;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if(self.transition.transitionEnable &&
       [self.transitionDelegate respondsToSelector:@selector(xa_slideToNextViewController:)]){
        return self.transition.interactive;
    }
    return nil;
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    self.nc.xa_grTransitioning = YES;
    return YES;
}

#pragma mark - Getter/Setter
- (BOOL)hasConfigCompletion{
    return self.nc != nil;
}

- (void)setTransitionType:(XATransitionType)transitionType{
    _transitionType = transitionType;
    self.transition = [XATransitionFactory handlerWithType:transitionType
                                      navigationController:self.nc
                                        transitionDelegate:self.transitionDelegate];
}

- (void)setTransitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    _transitionDelegate = transitionDelegate;
    self.transition.transitionDelegate = transitionDelegate;
    
}
@end
