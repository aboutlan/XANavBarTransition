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
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> interactivePopDelegate;
@property (nonatomic, strong) XABaseTransition *transition;
@property (nonatomic, strong) UIPanGestureRecognizer *interactivPopPan;
@property (nonatomic, assign) BOOL  hasConfigCompletion;
@property (nonatomic, assign, readwrite) XATransitionType transitionType;
@property (nonatomic, assign, readwrite) BOOL isTransitioning;
@property (nonatomic, weak,   readwrite) UINavigationController  *nc;
@property (nonatomic, weak,   readwrite) id<XATransitionDelegate> transitionDelegate;
@end

@implementation XATransitionManager
#pragma mark - Setup
+ (void)load{
    //交换导航控制器的手势进度转场方法,来监听手势滑动的进度
    SEL percentOriginalSEL =  NSSelectorFromString(@"_updateInteractiveTransition:");
    SEL percentSwizzledSEL =  NSSelectorFromString(@"xa_updateInteractiveTransition:");
    [self swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:percentOriginalSEL swizzledSEL:percentSwizzledSEL];
    
    //交换导航控制器的popViewControllerAnimated:方法,来监听什么时候当前控制被back
    SEL popOriginalSEL =  @selector(popViewControllerAnimated:);
    SEL popSwizzledSEL =  NSSelectorFromString(@"xa_popViewControllerAnimated:");
    [self swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:popOriginalSEL swizzledSEL:popSwizzledSEL];
    
    SEL pushOriginalSEL =  @selector(pushViewController:animated:);
    SEL pushSwizzledSEL =  NSSelectorFromString(@"xa_pushViewController:animated:");
    [self swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:pushOriginalSEL swizzledSEL:pushSwizzledSEL];
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
+ (void)swizzlingMethodWithOrginClass:(Class)orginClass
                        swizzledClass:(Class)swizzledClass
                          originalSEL:(SEL)originalSEL
                          swizzledSEL:(SEL)swizzledSEL{
    
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
    [self createFullScreenPopGestureRecognizer:nc];
}

- (void)unInitTransitionWithNc:(UINavigationController *)nc{
    [self releaseResource];
}


- (void)createFullScreenPopGestureRecognizer:(UINavigationController *)nc{
    static __weak UINavigationController *currentPopNc = nil;
    if(self.interactivPopPan == nil ||
        currentPopNc != nc){
        currentPopNc = nc;
        //添加全屏的滑动手势
        UIGestureRecognizer *navPanPopGr = currentPopNc.interactivePopGestureRecognizer;
        self.interactivePopDelegate = currentPopNc.interactivePopGestureRecognizer.delegate;
        NSArray *targets = [navPanPopGr valueForKey:@"_targets"];
        id desTarget     = [targets firstObject];
        id target        = [desTarget valueForKey:@"_target"];
        SEL transitionSEL  = NSSelectorFromString(@"handleNavigationTransition:");
        self.interactivPopPan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:transitionSEL];
        self.interactivPopPan.delegate = self;
        [currentPopNc.view addGestureRecognizer:self.interactivPopPan];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [XATransitionManager swizzlingMethodWithOrginClass:[target class] swizzledClass:[self class] originalSEL:transitionSEL swizzledSEL:@selector(xa_handleNavigationTransition:)];
        });
      
    }
    self.interactivPopPan.delegate = self;
    self.interactivPopPan.enabled  = YES;
}

- (void)xa_handleNavigationTransition:(UIGestureRecognizer *)pan{
    [self xa_handleNavigationTransition:pan];
    UINavigationController *nc = [XATransitionManager sharedManager].nc;
    if (pan.state == UIGestureRecognizerStateBegan) {
        nc.xa_Transitioning = YES;
        
    }  else if (pan.state == UIGestureRecognizerStateEnded) {
        nc.xa_Transitioning = NO;
    }
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
    self.transitionType = XATransitionTypeUnknow;
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
       [self.transitionDelegate respondsToSelector:@selector(xa_nextViewControllerInTransitionType:)]){
        return self.transition.interactive;
    }
    return nil;
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
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
        
        if(self.nc.viewControllers.count <= 1){//栈底控制器不需要
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

- (void)setTransitionDelegate:(id<XATransitionDelegate>)transitionDelegate{
    _transitionDelegate = transitionDelegate;
    self.transition.transitionDelegate = transitionDelegate;
}
@end

