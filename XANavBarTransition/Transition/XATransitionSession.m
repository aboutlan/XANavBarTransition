//
//  XATransitionSession.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XATransitionSession.h"
#import "XATransitionFactory.h"
#import "XANavBarTransitionTool.h"
#import "XANavigationControllerObserver.h"
#import "UIViewController+XANavBarTransition.h"
#import "UINavigationController+XANavBarTransition.h"
#import <objc/message.h>

@interface XATransitionSession()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) XABaseTransition *transition;
@property (nonatomic, assign, readwrite) XATransitionMode transitionMode;
@property (nonatomic, assign, readwrite) XATransitionAction transitionAction;
@property (nonatomic, weak,   readwrite) UINavigationController  *nc;
@property (nonatomic, weak,   readwrite) id<XATransitionDelegate> transitionDelegate;
@end

@implementation XATransitionSession
#pragma mark - Setup
+ (void)load{
    SEL popOriginalSEL =  @selector(popViewControllerAnimated:);
    SEL popSwizzledSEL =  NSSelectorFromString(@"xa_popViewControllerAnimated:");
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:popOriginalSEL swizzledSEL:popSwizzledSEL];
    
    
    SEL pushOriginalSEL =  @selector(pushViewController:animated:);
    SEL pushSwizzledSEL =  NSSelectorFromString(@"xa_pushViewController:animated:");
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:pushOriginalSEL swizzledSEL:pushSwizzledSEL];
}

#pragma mark - Action
- (instancetype)initSessionWithNc:(UINavigationController *)nc
                   transitionMode:(XATransitionMode)transitionMode
                 transitionAction:(XATransitionAction)transitionAction
               transitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    if(self = [super init]){
        self.nc = nc;
        self.transitionMode     = transitionMode;
        self.transitionAction   = transitionAction;
        self.transitionDelegate = transitionDelegate;
        self.transition = [XATransitionFactory handlerWithNc:nc
                                              transitionMode:transitionMode
                                            transitionAction:transitionAction
                                          transitionDelegate:transitionDelegate];
        [self.nc.xa_ncObserver configWithTransition:self.transition];
    }
    return  self;
}

- (void)unInitSessionWithNc:(UINavigationController *)nc{
    [self releaseResource];
}

- (void)xa_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    UIViewController *topVC = nc.topViewController;
    viewController.xa_transitionMode = topVC.xa_transitionMode;//pushedViewController默认延续相同的转场模式
    [self xa_pushViewController:viewController animated:animated];
    dealInteractionNotify(viewController, nc);
}


- (UIViewController *)xa_popViewControllerAnimated:(BOOL)animated{
   
    UIViewController *popVc    = [self xa_popViewControllerAnimated:animated];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    UIViewController *topVC = nc.topViewController;
    dealInteractionNotify(topVC,nc);
    return popVc;
}

#pragma mark - Deal
void dealInteractionNotify(UIViewController *desVc,UINavigationController *nc){
    if (desVc != nil  && nc != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = desVc.transitionCoordinator;
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
}

void dealInteractionEndAction(id<UIViewControllerTransitionCoordinatorContext> context,UINavigationController *nc){
    //处理导航栏的透明度状态
    if ([context isCancelled]) {// 取消了(还在当前页面)
        //根据剩余的进度来计算动画时长xa_changeNavBarAlpha
        CGFloat animdDuration = [context transitionDuration] * [context percentComplete];
        CGFloat fromVCAlpha   = [context viewControllerForKey:UITransitionContextFromViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [nc xa_changeNavBarAlpha:fromVCAlpha];
        }completion:^(BOOL finished) {
            nc.xa_isTransitioning = NO;
        }];
        
    } else {// 自动完成(pop到上一个界面了)
        
        CGFloat animdDuration = [context transitionDuration] * (1 -  [context percentComplete]);
        CGFloat toVCAlpha     = [context viewControllerForKey:UITransitionContextToViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [nc xa_changeNavBarAlpha:toVCAlpha];
        }completion:^(BOOL finished) {
            nc.xa_isTransitioning = NO;
        }];
    };
}

- (void)releaseResource{
    self.nc = nil;
    [self.nc.xa_ncObserver cleanConfig];
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
    
    if(self.transition.percentInteractive){
        navigationController.xa_isTransitioning = YES;
    }
    return self.transition.percentInteractive;
}


#pragma mark - Getter/Setter
- (void)setTransitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    _transitionDelegate = transitionDelegate;
    self.transition.transitionDelegate = transitionDelegate;
}


- (void)setTransitionEnable:(BOOL)transitionEnable{
    self.transition.transitionEnable = transitionEnable;
}

- (BOOL)transitionEnable{
    return self.transition.transitionEnable;
}
@end

