//
//  XABaseTransition.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XABaseTransitionAnimation.h"
@interface XABaseTransition : NSObject{
    @protected
    XABaseTransitionAnimation *_animation;
    
}
@property (nonatomic, assign) BOOL transitionEnable;
@property (nonatomic, strong) XABaseTransitionAnimation *animation;
@property (nonatomic, copy)   dispatch_block_t transitionCompletion;
@end
