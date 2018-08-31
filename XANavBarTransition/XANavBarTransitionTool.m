//
//  XANavBarTransitionTool.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/8/9.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XANavBarTransitionTool.h"
#import <objc/message.h>
@implementation XANavBarTransitionTool


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

@end
