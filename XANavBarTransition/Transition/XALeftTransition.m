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

- (TransitionType)transitionType{
    return TransitionTypeLeft;
}

- (XABaseTransitionAnimation *)animation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation;
        });
    }
    return _animation;
}
@end
