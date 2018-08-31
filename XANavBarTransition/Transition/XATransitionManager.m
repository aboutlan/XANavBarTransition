//
//  XATransitionManager.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XATransitionManager.h"
#import "XATransitionFactory.h"
#import "XANavBarTransitionTool.h"
#import "UIViewController+XANavBarTransition.h"
#import "UINavigationController+XANavBarTransition.h"

@interface XATransitionManager()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL  hasConfigCompletion;
@property (nonatomic, strong, readwrite) XABaseTransition *transition;
@property (nonatomic, assign, readwrite) XATransitionMode transitionMode;
@property (nonatomic, weak,   readwrite) UINavigationController  *nc;
@property (nonatomic, weak,   readwrite) id<XATransitionDelegate> transitionDelegate;
@end

@implementation XATransitionManager
#pragma mark - Setup
+ (void)load{
    SEL popOriginalSEL =  @selector(popViewControllerAnimated:);
    SEL popSwizzledSEL =  NSSelectorFromString(@"xa_popViewControllerAnimated:");
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:popOriginalSEL swizzledSEL:popSwizzledSEL];
    
    
    SEL pushOriginalSEL =  @selector(pushViewController:animated:);
    SEL pushSwizzledSEL =  NSSelectorFromString(@"xa_pushViewController:animated:");
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:pushOriginalSEL swizzledSEL:pushSwizzledSEL];
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
- (void)configTransitionWithNc:(UINavigationController *)nc
                transitionMode:(XATransitionMode)transitionMode
            transitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    self.nc = nc;
    self.nc.delegate = self;
    self.transitionMode = transitionMode;
    self.transitionDelegate = transitionDelegate;
    self.transition = [XATransitionFactory handlerWithNc:nc
                                          transitionMode:transitionMode
                                        transitionDelegate:transitionDelegate];
    
}

- (void)unInitTransitionWithNc:(UINavigationController *)nc{
    [self releaseResource];
}

- (void)xa_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self xa_pushViewController:viewController animated:animated];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    if (nc != nil && viewController != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = viewController.transitionCoordinator;
        //监听push的完成或取消操作
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


- (UIViewController *)xa_popViewControllerAnimated:(BOOL)animated{
   
    UIViewController *popVc    = [self xa_popViewControllerAnimated:animated];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    UIViewController *topVC = [nc.viewControllers lastObject];
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        //监听pop的完成或取消操作
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
void dealInteractionEndAction(id<UIViewControllerTransitionCoordinatorContext> context,UINavigationController *nc){
    //处理导航栏的透明度状态
    if ([context isCancelled]) {// 取消了(还在当前页面)
        //根据剩余的进度来计算动画时长xa_changeNavBarAlpha
        CGFloat animdDuration = [context transitionDuration] * [context percentComplete];
        CGFloat fromVCAlpha   = [context viewControllerForKey:UITransitionContextFromViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [nc xa_changeNavBarAlpha:fromVCAlpha];
        }completion:nil];
        
    } else {// 自动完成(pop到上一个界面了)
        
        CGFloat animdDuration = [context transitionDuration] * (1 -  [context percentComplete]);
        CGFloat toVCAlpha     = [context viewControllerForKey:UITransitionContextToViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [nc xa_changeNavBarAlpha:toVCAlpha];
        }completion:nil];
    };
   
}

- (void)releaseResource{
    self.nc.xa_Transitioning = NO;
    self.transitionMode = XATransitionModeUnknow;
    self.transition = nil;
    self.transitionDelegate = nil;
}

#pragma mark - <UINavigationControllerDelegate>
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    UIViewController *nextVc  = self.transition.nextVC;
    XABaseTransitionAnimation *transitionAnim = nil;
    if(operation == UINavigationControllerOperationPush &&
       nextVc == toVC){
        transitionAnim = self.transition.pushAnimation;
    }else if(operation == UINavigationControllerOperationPop){
        transitionAnim = self.transition.popAnimation;
    }

    return transitionAnim;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if(self.transition.transitionEnable &&
       [self.transitionDelegate respondsToSelector:@selector(xa_nextViewControllerInTransitionMode:)]){
        return self.transition.interactive;
    }
    return nil;
}


#pragma mark - Getter/Setter
- (BOOL)hasConfigCompletion{
    return self.nc != nil;
}

- (void)setTransitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    _transitionDelegate = transitionDelegate;
    self.transition.transitionDelegate = transitionDelegate;
}
@end

