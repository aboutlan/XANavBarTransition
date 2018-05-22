//
//  XALeftTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XALeftTransition.h"
#import "XALeftTransitionAnimation.h"

@interface XALeftTransition()

@end

@implementation XALeftTransition


- (XABaseTransitionAnimation *)animation{
    if(_animation == nil){
        _animation = [[XALeftTransitionAnimation alloc]init];
        _animation.transitionCompletion = self.transitionCompletion;
    }
    return _animation;
}
@end
