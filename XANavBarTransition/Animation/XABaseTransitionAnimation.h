//
//  XABaseTransitionAnimation.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/22.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XABaseTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,copy) dispatch_block_t transitionCompletion;
@end
