//
//  XARightTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/23.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XARightTransition.h"
#import "XARightTransitionAnimation.h"
@implementation XARightTransition

#pragma mark - Getter/Setter
- (XATransitionMode)transitionMode{
    return XATransitionModeRight;
}


- (XABaseTransitionAnimation *)pushAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XARightTransitionAnimation alloc]init];
            animation.animationType = XAAnimTransitionTypePush;
            animation;
        });
    }
    return _animation;
}


- (XABaseTransitionAnimation *)popAnimation{
    if(_animation == nil){
        _animation = ({
            XABaseTransitionAnimation *animation =  [[XARightTransitionAnimation alloc]init];
            animation.animationType = XAAnimTransitionTypePop;
            animation;
        });
    }
    return _animation;
}
@end
