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
#import "UINavigationController+XANavBarTransition.h"
#import "SecondViewController.h"
@interface XATransitionManager()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController  *nc;
@property (nonatomic, assign) BOOL  hasConfigCompletion;
@property (nonatomic, strong) XABaseTransition *transition;
@end

@implementation XATransitionManager

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

#pragma mark - Setup
- (void)setupManager{
    
    
    
}


#pragma mark - Action
- (void)configTransition:(UINavigationController *)nc{
    self.nc = nc;
    self.nc.delegate = self;
    self.transition  = [XATransitionFactory handlerWithType:self.transitionType navigationController:self.nc];
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
