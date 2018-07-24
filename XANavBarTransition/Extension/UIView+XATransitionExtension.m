//
//  UIView+XATransitionExtension.m
//  YXXiaoKaXiuSDK
//
//  Created by xangam on 2018/7/24.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "UIView+XATransitionExtension.h"

@implementation UIView (XATransitionExtension)


- (BOOL)xa_isDisplaying{
    UIWindow *keyWindow   = [UIApplication sharedApplication].keyWindow;
    CGRect inWindowFrame  = [self.superview convertRect:self.frame toView:keyWindow];
    CGRect windowBounds   = keyWindow.bounds;
    BOOL isOverlap = CGRectIntersectsRect(inWindowFrame, windowBounds);
    
    BOOL isDisplaying = self.hidden == NO && self.alpha > 0.01 && isOverlap;
    return isDisplaying;
}

@end
