//
//  MessageViewController.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/9/3.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XANavBarTransition.h"
@interface MessageViewController : UIViewController<XATransitionDelegate>
@property (nonatomic, assign) NSInteger titleIndex;
@end
