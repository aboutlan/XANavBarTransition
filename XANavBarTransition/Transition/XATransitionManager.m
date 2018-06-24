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
@interface XATransitionManager()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
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


- (instancetype)init{
    if(self = [super init]){
        [self setupManager];
    }
    return self;
}


- (void)setupManager{
}
#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    self.nc.xa_grTransitioning = YES;
    return YES;
}

#pragma mark - Action
+ (void)swizzlingMethodWithOriginal:(SEL)originalSEL swizzled:(SEL)swizzledSEL{
    
    Method orginMethod   = class_getInstanceMethod([UINavigationController class], originalSEL);
    Method swizzldMethod = class_getInstanceMethod(self, swizzledSEL);
    BOOL addSuccess = class_addMethod([UINavigationController class] , originalSEL, method_getImplementation(swizzldMethod), method_getTypeEncoding(swizzldMethod));
    if(addSuccess){
        class_replaceMethod(self , swizzledSEL, method_getImplementation(orginMethod), method_getTypeEncoding(orginMethod));
        
    }else{
        method_exchangeImplementations(orginMethod, swizzldMethod);
    }
}

- (void)configTransition:(UINavigationController *)nc{
    self.nc = nc;
    self.nc.delegate = self;
    self.transition  = [XATransitionFactory handlerWithType:self.transitionType navigationController:self.nc];
}


#pragma mark  - Transition
- (void)xa_updateInteractiveTransition:(CGFloat)percentComplete{
    [self xa_updateInteractiveTransition:percentComplete];
    UIViewController *topVC = self.nc.topViewController;
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
            [self.nc xa_changeNavBarAlpha:newAlpha];
        }
    }
}


- (UIViewController *)xa_popViewControllerAnimated:(BOOL)animated{
    UIViewController *popVc =  [self xa_popViewControllerAnimated:animated];
    if(self.nc.viewControllers.count <= 0){
        return popVc;
    }
    UIViewController *topVC = [self.nc.viewControllers lastObject];
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        
        //监听手势返回的交互改变,如手势滑动过程当中松手就会回调block
        if (coordinator != nil) {
            if([[UIDevice currentDevice].systemVersion intValue]  >= 10){//适配iOS10
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    [self dealInteractionEndAction:context];
                }];
            }else{
                [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self dealInteractionEndAction:context];
                }];
            }
        }
    }
    return popVc;
}


- (void)xa_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //    if([self.childViewControllers containsObject:viewController]){
    //        NSLog(@"被return了");
    //        return;
    //    }
    
    [self xa_pushViewController:viewController animated:animated];
    if (viewController != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = viewController.transitionCoordinator;
        
        //监听手势返回的交互改变,如手势滑动过程当中松手就会回调block
        if (coordinator != nil) {
            if([[UIDevice currentDevice].systemVersion intValue]  >= 10){//适配iOS10
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    [self dealInteractionEndAction:context];
                }];
            }else{
                [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self dealInteractionEndAction:context];
                }];
            }
        }
    }
}


- (void)dealInteractionEndAction:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 取消了(还在当前页面)
        //根据剩余的进度来计算动画时长xa_changeNavBarAlpha
        CGFloat animdDuration = [context transitionDuration] * [context percentComplete];
        CGFloat fromVCAlpha   = [context viewControllerForKey:UITransitionContextFromViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [self.nc xa_changeNavBarAlpha:fromVCAlpha];
        }completion:^(BOOL finished) {
            self.nc.xa_grTransitioning = NO;
        }];
        
    } else {// 自动完成(pop到上一个界面了)
        
        CGFloat animdDuration = [context transitionDuration] * (1 -  [context percentComplete]);
        CGFloat toVCAlpha     = [context viewControllerForKey:UITransitionContextToViewControllerKey].xa_navBarAlpha;
        [UIView animateWithDuration:animdDuration animations:^{
            [self.nc xa_changeNavBarAlpha:toVCAlpha];
        }completion:^(BOOL finished) {
            self.nc.xa_grTransitioning = NO;
        }];
    };
    
}


#pragma mark - <UINavigationControllerDelegate>
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //self.transition.transitionEnable = !(viewController == [self.nc.viewControllers firstObject]); //该控制器为根控制器,则不开启转场滑动功能
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    if(operation == UINavigationControllerOperationPush &&
//       [self.xa_fullScreenPopDelegate respondsToSelector:@selector(xa_leftSlideWithViewController:)] ){
//        XALeftTransitionAnimation *push = [[XALeftTransitionAnimation alloc]init];
//        __weak typeof(self) weakSelf = self;
//        push.transitionCompletionBlock = ^{
//            [weakSelf destroyLeftSlidePan];
//        };
//        return push;
//    }
    //xa_slideToNextViewController的值和toView一致
    
    
    UIViewController *nextVc = [self.nc.xa_transitionDelegate xa_slideToNextViewController:navigationController transitionType:self.transitionType];
    if(operation == UINavigationControllerOperationPush &&
       nextVc == toVC){
        return self.transition.animation;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if(self.transition.transitionEnable &&
       [self.nc.xa_transitionDelegate respondsToSelector:@selector(xa_slideToNextViewController:transitionType:)]){
        return self.transition.interactive;
    }
    return nil;
}


#pragma mark - Getter/Setter
- (BOOL)hasConfigCompletion{
    return self.nc != nil;
}

- (void)setTransitionType:(TransitionType)transitionType{
    _transitionType = transitionType;
    self.transition = [XATransitionFactory handlerWithType:transitionType navigationController:self.nc];
}
@end
