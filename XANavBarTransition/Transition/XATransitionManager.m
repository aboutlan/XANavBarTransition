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
#import <objc/message.h>
@interface XATransitionManager()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UINavigationController  *nc;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> interactivePopDelegate;
@property (nonatomic, strong) XABaseTransition *transition;
@property (nonatomic, strong) UIPanGestureRecognizer *interactivPopPan;
@property (nonatomic, assign) BOOL  hasConfigCompletion;
@property (nonatomic, assign, readwrite) XATransitionType transitionType;
@property (nonatomic, weak,   readwrite) id<XATransitionDelegate> transitionDelegate;
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

- (void)configTransitionWithNc:(UINavigationController *)nc
                transitionType:(XATransitionType)transitionType
            transitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    self.nc = nc;
    self.nc.delegate = self;
    self.nc.interactivePopGestureRecognizer.delegate = self;
    self.transitionType = transitionType;
    self.transitionDelegate = transitionDelegate;
    self.transition = [XATransitionFactory handlerWithType:transitionType
                                           navigationController:nc
                                             transitionDelegate:transitionDelegate];
    [self createFullScreenPopGestureRecognizer];
}

- (void)createFullScreenPopGestureRecognizer{
    if(!self.interactivPopPan){
        //添加全屏的滑动手势
        UIGestureRecognizer *navPanPopGr =  self.nc.interactivePopGestureRecognizer;
        self.interactivePopDelegate = self.nc.interactivePopGestureRecognizer.delegate;
        NSArray *targets = [navPanPopGr valueForKey:@"_targets"];
        id desTarget     = [targets firstObject];
        id target        = [desTarget valueForKey:@"_target"];
        SEL transitionAction  = NSSelectorFromString(@"handleNavigationTransition:");
        self.interactivPopPan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:transitionAction];
        self.interactivPopPan.delegate = self;
        [self.nc.view addGestureRecognizer:self.interactivPopPan];
    }
    self.interactivPopPan.delegate = self;
    self.interactivPopPan.enabled  = YES;
}


- (void)xa_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self xa_pushViewController:viewController animated:animated];
    UINavigationController *nc = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : nil;
    
    if (nc != nil && viewController != nil) {
        
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

- (void)releaseResource{
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
    __weak typeof(self) weakSelf = self;
    transitionAnim.transitionCompletion = ^{
        [weakSelf releaseResource];
    };
    return transitionAnim;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if(self.transition.transitionEnable &&
       [self.transitionDelegate respondsToSelector:@selector(xa_nextViewControllerInTransitionType:)]){
        return self.transition.interactive;
    }
    return nil;
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    self.nc.xa_grTransitioning = YES;
    
    if(gestureRecognizer == self.interactivPopPan){
        UIPanGestureRecognizer * panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point     = [panGestureRecognizer translationInView:nil];
        CGPoint velocity  = [panGestureRecognizer velocityInView:nil];
        
        if (fabs(velocity.y) > fabs(velocity.x)) {//垂直方向不处理
            return NO;
        }
        
        if(point.x < 0){ //向左边滑动不处理
            return NO;
        }
        
        return [self.nc xa_isPopEnable];//Pop功能开关
    }
    return NO;
}

#pragma mark - Getter/Setter
- (BOOL)hasConfigCompletion{
    return self.nc != nil;
}

- (void)setTransitionType:(XATransitionType)transitionType{
    _transitionType = transitionType;
}

- (void)setTransitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    _transitionDelegate = transitionDelegate;
    self.transition.transitionDelegate = transitionDelegate;
}
@end

