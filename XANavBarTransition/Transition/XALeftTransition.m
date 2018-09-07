//
//  XALeftTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XALeftTransition.h"
#import "XALeftTransitionAnimation.h"
#import "XATransitionSession.h"
@interface XALeftTransition()
@end

@implementation XALeftTransition
#pragma mark - Getter/Setter
- (XATransitionMode)transitionMode{
    return XATransitionModeLeft;
}

- (XABaseTransitionAnimation *)pushAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation.animationType = XAAnimTransitionTypePush;
            animation;
        });
    }
    return _animation;
}


- (XABaseTransitionAnimation *)popAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XALeftTransitionAnimation alloc]init];
            animation.animationType = XAAnimTransitionTypePop;
            animation;
        });
    }
    return _animation;
}

@end
