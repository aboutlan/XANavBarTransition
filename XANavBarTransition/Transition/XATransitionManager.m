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
    self.transition  = [XATransitionFactory handlerWithType:self.transitionType];
}

#pragma mark - <UINavigationControllerDelegate>
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.transition.transitionEnable = !(viewController == [self.nc.viewControllers firstObject]); //该控制器为根控制器,则不开启转场滑动功能
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
    
    if(operation == UINavigationControllerOperationPush){
        
        self.transition.transitionCompletion = ^{
            
        };
        
        return self.transition.animation;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    if(self.fullscreenPushGestureRecognizer &&
//       [self.xa_fullScreenPopDelegate respondsToSelector:@selector(xa_leftSlideWithViewController:)]){
//
//        return self.fullscreenPushInteractiveTransition;
//    }
//
    return nil;
}



#pragma mark - Getter/Setter
- (BOOL)hasConfigCompletion{
    return self.nc != nil;
}


@end
