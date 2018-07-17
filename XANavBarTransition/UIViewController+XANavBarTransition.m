//
//  UIViewController+XANavBarTransition.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "UIViewController+XANavBarTransition.h"
#import <objc/message.h>
#import "XANavBarTransition.h"

@implementation UIViewController (XANavBarTransition)

#pragma mark - Getter/Setter
- (CGFloat)xa_navBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}

- (void)setXa_navBarAlpha:(CGFloat)xa_navBarAlpha{
    xa_navBarAlpha = MAX(0,MIN(1, xa_navBarAlpha));
    self.xa_isSetBarAlpha = YES;
    objc_setAssociatedObject(self, @selector(xa_navBarAlpha), @(xa_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController xa_changeNavBarAlpha:xa_navBarAlpha];
}

- (XATransitionType)xa_transitionType{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setXa_transitionType:(XATransitionType)xa_transitionType{
    objc_setAssociatedObject(self, @selector(xa_transitionType), @(xa_transitionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController xa_changeTransitionType:xa_transitionType];
}

- (id<XATransitionDelegate>)xa_transitionDelegate{
    return objc_getAssociatedObject(self, _cmd) ;
}

- (void)setXa_transitionDelegate:(id<XATransitionDelegate>)xa_transitionDelegate{
    objc_setAssociatedObject(self,@selector(xa_transitionDelegate),xa_transitionDelegate,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController xa_changeTransitionDelegate:xa_transitionDelegate];
}

- (BOOL)xa_isSetBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)boolValue];
}

- (void)setXa_isSetBarAlpha:(BOOL)xa_isSetBarAlpha{
    objc_setAssociatedObject(self, @selector(xa_isSetBarAlpha), @(xa_isSetBarAlpha), OBJC_ASSOCIATION_ASSIGN);
    
}

@end
