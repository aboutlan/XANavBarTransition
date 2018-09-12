//
//  XANavigationControllerObserver.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/9/9.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XANavigationControllerObserver.h"
#import "UINavigationController+XANavBarTransition.h"
#import "XATransitionSession.h"
#import "XABaseTransitionAnimation.h"
#import "XABaseTransition.h"
@interface XANavigationControllerObserver()
@property (nonatomic, weak, readwrite) XABaseTransition *transition;
@property (nonatomic, weak, readwrite) UINavigationController *nc;
@end
@implementation XANavigationControllerObserver

- (instancetype)initWithNc:(UINavigationController *)nc{
    if(self = [super init]){
        self.nc = nc;
        self.nc.delegate = self;
    }
    return self;
}

#pragma mark - Action
- (void)configWithTransition:(XABaseTransition *)transition{
    self.transition = transition;
}

- (void)cleanConfig{
    self.transition = nil;
}

#pragma mark - <UINavigationControllerDelegate>
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if([self.delegate respondsToSelector: @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]){
        return  [self.delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }else if(self.transition != nil){
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
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    if([self.delegate respondsToSelector: @selector(navigationController:interactionControllerForAnimationController:)]){
        return  [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }else if(self.transition != nil){
        return self.transition.percentInteractive;
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self.delegate respondsToSelector: @selector(navigationController:willShowViewController:animated:)]){
        [self.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self.delegate respondsToSelector: @selector(navigationController:didShowViewController:animated:)]){
        [self.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController{
    if([self.delegate respondsToSelector: @selector(navigationControllerSupportedInterfaceOrientations:)]){
        return [self.delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskPortrait;
    
}
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController{
    
    if([self.delegate respondsToSelector: @selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]){
        return [self.delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

@end
