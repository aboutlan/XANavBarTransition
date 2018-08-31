//
//  XABaseTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XABaseTransition.h"
#import "XANavBarTransition.h"
#import "XABaseTransition.h"


@interface XABaseTransition()
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

- (void)setupWithNc:(UINavigationController *)nc
             action:(XATransitionAction)action
           delegate:(id<XATransitionDelegate>)delegate{
    self.nc = nc;
    self.transitionView     = nc.view;
    self.transitionDelegate = delegate;
    [self setupGestureRecognize:nc.view action:action];
}

- (void)setupGestureRecognize:(UIView *)transitionView
                       action:(XATransitionAction)action{
    self.pushInteractivePan.delegate = self;
    self.popInteractivePan.delegate  = self;
    self.pushTransitionEnable = action == XATransitionActionOnlyPush || action == XATransitionActionPushPop;
    self.popTransitionEnable  = action == XATransitionActionOnlyPop  || action == XATransitionActionPushPop;
    [transitionView addGestureRecognizer:self.pushInteractivePan];
}

#pragma mark - Action
- (void)interactiveTransitioningEvent:(UIPanGestureRecognizer *)pan{
    
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
- (CGFloat)calcTransitioningX:(CGPoint)translationPoint{
    return 0;
}


#pragma mark - Getter/Setter
- (UIPercentDrivenInteractiveTransition *)interactive{
    if(_interactive == nil){
        _interactive = ({
            UIPercentDrivenInteractiveTransition *interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
            interactive.completionCurve = UIViewAnimationCurveEaseOut;
            interactive.completionSpeed = 0.99;
            interactive;
        });
    }
    return _interactive;
}

- (UIPanGestureRecognizer *)pushInteractivePan{
    if(_pushInteractivePan == nil){
        _pushInteractivePan = ({
            UIPanGestureRecognizer *interactiveGR  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveTransitioningEvent:)];
            interactiveGR;
        });
    }
    return _pushInteractivePan;
}


- (UIPanGestureRecognizer *)popInteractivePan{
    if(_popInteractivePan == nil){
        _popInteractivePan = ({
            UIPanGestureRecognizer *interactiveGR  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveTransitioningEvent:)];
            interactiveGR;
        });
    }
    return _popInteractivePan;
}

- (BOOL)pushTransitionEnable{
    return self.pushInteractivePan.enabled;
}

- (void)setPushTransitionEnable:(BOOL)pushTransitionEnable{
    self.pushInteractivePan.enabled  = pushTransitionEnable;
    self.pushInteractivePan.delegate = pushTransitionEnable ? self : nil;
}

- (BOOL)popTransitionEnable{
    return self.popInteractivePan.enabled;
}

- (void)setPopTransitionEnable:(BOOL)popTransitionEnable{
    self.popInteractivePan.enabled  = popTransitionEnable;
    self.popInteractivePan.delegate = popTransitionEnable ? self : nil;
}

@end
