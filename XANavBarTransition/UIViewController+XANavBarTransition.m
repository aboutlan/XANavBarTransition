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



- (CGFloat)navBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}

- (void)setNavBarAlpha:(CGFloat)navBarAlpha{
    if(navBarAlpha > 1){
        navBarAlpha = 1;
    }
    if(navBarAlpha < 0){
        navBarAlpha = 0;
    }
    objc_setAssociatedObject(self, @selector(navBarAlpha), @(navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController changeNavBarAlpha:navBarAlpha];
}


@end
