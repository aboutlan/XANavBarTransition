//
//  XANavBarTransitionTool.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/8/9.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XANavBarTransitionTool : NSObject
+ (void)swizzlingMethodWithOrginClass:(Class)orginClass
                        swizzledClass:(Class)swizzledClass
                          originalSEL:(SEL)originalSEL
                          swizzledSEL:(SEL)swizzledSEL;


@end
