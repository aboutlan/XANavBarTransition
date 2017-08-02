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
@interface UIViewController()
/**
 当前控制器是否设置过导航栏透明度
 */
@property(nonatomic,assign)BOOL xa_didSetBarAlpha;

@end


@implementation UIViewController (XANavBarTransition)

+ (void)load{
    
    SEL  originalAppearSEL  = @selector(viewWillAppear:);
    SEL  swizzledAppearSEL = @selector(xa_viewWillAppear:);
    Method originalAppearMethod = class_getInstanceMethod(self, originalAppearSEL);
    Method swizzledAppearMethod = class_getInstanceMethod(self, swizzledAppearSEL);
    
    BOOL success = class_addMethod(self, originalAppearSEL, method_getImplementation(swizzledAppearMethod), method_getTypeEncoding(swizzledAppearMethod));
    if (success) {
        class_replaceMethod(self, swizzledAppearSEL, method_getImplementation(originalAppearMethod), method_getTypeEncoding(originalAppearMethod));
    } else {
        method_exchangeImplementations(originalAppearMethod, swizzledAppearMethod);
    }
}




#pragma mark  - Transition
- (void)xa_viewWillAppear:(BOOL)animated{
    [self xa_viewWillAppear:animated];
    if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
       self.xa_navBarAlpha){//只有当前控制器设置过NavAlpha才在控制器显示的时候重置
        [self.navigationController xa_changeNavBarAlpha:self.xa_navBarAlpha];
    }
}



#pragma mark - Getter/Setter
- (CGFloat)xa_navBarAlpha{
    return [objc_getAssociatedObject(self, _cmd)floatValue] ;
}

- (void)setXa_navBarAlpha:(CGFloat)xa_navBarAlpha{
    if(xa_navBarAlpha > 1){
        xa_navBarAlpha = 1;
    }
    if(xa_navBarAlpha < 0){
        xa_navBarAlpha = 0;
    }
    self.xa_didSetBarAlpha = YES;
    objc_setAssociatedObject(self, @selector(xa_navBarAlpha), @(xa_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController xa_changeNavBarAlpha:xa_navBarAlpha];
}


- (void)setXa_didSetBarAlpha:(BOOL)xa_didSetBarAlpha{
    objc_setAssociatedObject(self, @selector(xa_didSetBarAlpha), @(xa_didSetBarAlpha), OBJC_ASSOCIATION_ASSIGN);
    
}

- (BOOL)xa_didSetBarAlpha{
    
   return [objc_getAssociatedObject(self, _cmd)boolValue];
}



@end
