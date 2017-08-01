//
//  UINavigationController+XANavBarTransition.m
//  XANavBarTransitionDemo
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "UINavigationController+XANavBarTransition.h"

@implementation UINavigationController (XANavBarTransition)





#pragma mark - Alpha
- (void)changeNavBarAlpha:(CGFloat)navBarAlpha{
    
    NSMutableArray *barSubviews = [NSMutableArray array];
    //将导航栏的子控件添加到数组当中,取首个子控件设置透明度(防止导航栏上存在非导航栏自带的控件)
    for (UIView * view in self.navigationBar.subviews) {
        if(![view isMemberOfClass:[UIView class]]){
            [barSubviews addObject:view];
        }
    }
    UIView *barBackgroundView = [barSubviews firstObject];
    barBackgroundView.alpha = navBarAlpha;
    
}
@end
