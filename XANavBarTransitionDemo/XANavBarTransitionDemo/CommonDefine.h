//
//  CommonDefine.h
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/13.
//  Copyright © 2018年 Lan. All rights reserved.
//

#define XA_ADJUSTS_SCROLLVIEW_INSETS(scrollView)\
if (@available(iOS 11.0, *)) {\
if([scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
}\
} else {\
self.automaticallyAdjustsScrollViewInsets = NO;\
}
