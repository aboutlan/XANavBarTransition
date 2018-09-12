//
//  XABaseTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XABaseTransition.h"
#import "XANavBarTransition.h"
#import "XATransitionSession.h"
#import "XABaseTransitionAnimation.h"
#import "XANavBarTransitionTool.h"
#import "UIViewController+XANavBarTransition.h"


@interface XABaseTransition()
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, strong, readwrite) XABaseTransitionAnimation *pushAnimation;
@property (nonatomic, strong, readwrite) XABaseTransitionAnimation *popAnimation;
@property (nonatomic, assign, readwrite) XATransitionMode transitionMode;
@end


@implementation XABaseTransition
#pragma mark - Setup
+ (void)load{
    //交换导航控制器的手势进度转场方法,来监听手势滑动的进度
    SEL percentOriginalSEL =  NSSelectorFromString(@"_updateInteractiveTransition:");
    SEL percentSwizzledSEL =  NSSelectorFromString(@"xa_updateInteractiveTransition:");
    [XANavBarTransitionTool swizzlingMethodWithOrginClass:[UINavigationController class] swizzledClass:[self class] originalSEL:percentOriginalSEL swizzledSEL:percentSwizzledSEL];
}

- (instancetype)initWithNavigationController:(UINavigationController *)nc
                            transitionAction:(XATransitionAction)action
                          transitionDelegate:(id<XATransitionDelegate>)delegate{
    if(self = [super init]){
        [self setupWithNc:nc action:action delegate:delegate];
    }
    return self;
}

- (void)unInitWithVC:(UIViewController *)unInitVC{
    if([unInitVC.view.gestureRecognizers containsObject:self.interactivePan]){
        [unInitVC.view removeGestureRecognizer:self.interactivePan];
    }
    self.interactivePan = nil;
    self.nextVC = nil;
}

- (void)setupWithNc:(UINavigationController *)nc
             action:(XATransitionAction)action
           delegate:(id<XATransitionDelegate>)delegate{
    self.nc = nc;
    self.transitionView = nc.topViewController.view;
    self.transitionDelegate = delegate;
    [self setupGestureRecognizeWithAction:action];
}

- (void)setupGestureRecognizeWithAction:(XATransitionAction)action{
    self.interactivePan.delegate = self;
    self.transitionEnable = [self.nc xa_isTransitionEnable];
    self.pushTransitionEnable = action == XATransitionActionOnlyPush || action == XATransitionActionPushPop;
    self.popTransitionEnable  = action == XATransitionActionOnlyPop  || action == XATransitionActionPushPop;
    [self.transitionView addGestureRecognizer:self.interactivePan];
}

#pragma mark - Action
- (void)interactiveTransitioningEvent:(UIPanGestureRecognizer *)pan{
    if(pan == self.interactivePan){
        static NSTimeInterval beginTouchTime,endTouchTime;//beginTouchTime和endTouchTime这两个数据量主要是用于参考是否为轻扫
        CGPoint translationPoint = [pan translationInView:nil];
        CGFloat progress  = fabs(translationPoint.x / [UIScreen mainScreen].bounds.size.width) ;
        progress = MIN(1, MAX(progress, 0));
        if (pan.state == UIGestureRecognizerStateBegan) {
            self.nc.xa_isTransitioning = YES;
            beginTouchTime = [[NSDate date]timeIntervalSince1970];
            self.percentInteractive = [[UIPercentDrivenInteractiveTransition alloc] init];
            self.percentInteractive.completionCurve = UIViewAnimationCurveEaseOut;
            self.percentInteractive.completionSpeed = 0.99;
            if([self getPushCondition:self.beginPoint]){//push
                [self.nc pushViewController:self.nextVC animated:YES];
            }else {//pop
                [self.nc popViewControllerAnimated:YES];
            }
            [self.percentInteractive updateInteractiveTransition:0];
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            [self.percentInteractive updateInteractiveTransition:progress];
            
        } else if (pan.state == UIGestureRecognizerStateEnded) {
       
            endTouchTime = [[NSDate date]timeIntervalSince1970];
            CGFloat dValueTime = endTouchTime - beginTouchTime;
            if (progress > 0.3 || dValueTime <= 0.15f) {//dValueTime <= 0.15f 该条件用于判断是否为轻扫
                [self.percentInteractive finishInteractiveTransition];
            } else {
                [self.percentInteractive cancelInteractiveTransition];
            }
            self.nc.xa_isTransitioning = NO;
            self.percentInteractive = nil;
            if(self.transitionView != nil &&
               self.interactivePan != nil){
                [self.transitionView removeGestureRecognizer:self.interactivePan];
                self.interactivePan = nil;
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

- (BOOL)getPushCondition:(CGPoint)translationPoint{
    BOOL pushCondition = self.transitionMode == XATransitionModeLeft ? translationPoint.x < 0 :  translationPoint.x > 0;
    return pushCondition;
}

- (BOOL)getPopCondition:(CGPoint)translationPoint{
    BOOL popCondition = self.transitionMode == XATransitionModeLeft ? translationPoint.x > 0 :  translationPoint.x < 0;
    return popCondition;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer == self.interactivePan){
        CGPoint point     = [gestureRecognizer translationInView:nil];
        CGPoint velocity  = [gestureRecognizer velocityInView:nil];
        
        if (fabs(velocity.y) > fabs(velocity.x)) {//垂直方向不处理
            return NO;
        }
        if(self.nc.xa_isTransitioning){
            return NO;
        }
        
        self.beginPoint = point;
        if([self getPushCondition:point]){//push
            self.nextVC = [self.transitionDelegate xa_nextViewControllerInTransitionMode:self.transitionMode];//是否为有效的push控制器
            if(self.nextVC  == nil ||
               [self.nc.childViewControllers containsObject:self.nextVC]){
                return NO;
            }
            return self.pushTransitionEnable;
            
        }else if([self getPopCondition:point]){//pop
            
            if(self.nc.viewControllers.count <= 1){//栈底控制器不处理
                return NO;
            }
            return self.popTransitionEnable;
            
        }
        return NO;
    }
    return YES;
}

#pragma mark - Getter/Setter

- (UIPanGestureRecognizer *)interactivePan{
    if(_interactivePan == nil){
        _interactivePan = ({
            UIPanGestureRecognizer *interactiveGR  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveTransitioningEvent:)];
            interactiveGR;
        });
    }
    return _interactivePan;
}

- (void)setTransitionEnable:(BOOL)transitionEnable{
    self.interactivePan.enabled = transitionEnable;
}

- (BOOL)transitionEnable{
    return self.interactivePan.enabled;
}

@end
