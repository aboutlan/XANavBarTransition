//
//  XABaseTransitionAnimation.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/22.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XATransitionAnimationType){
    XAAnimTransitionTypePush,
    XAAnimTransitionTypePop
};

@interface XABaseTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) XATransitionAnimationType animationType;
@property (nonatomic, copy)   dispatch_block_t transitionCompletion;
@end
