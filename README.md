# XANavBarTransition[![Pod Version](https://img.shields.io/cocoapods/v/XANavBarTransition.svg?style=flat)](https://cocoapods.org/pods/XANavBarTransition)   [![License](https://img.shields.io/cocoapods/l/XANavBarTransition.svg?style=flat)](blob/master/License) 

A simple navigation bar smooth transition library.

## Feature

- Gesture drive full screen push or pop.

- Support sliding transition to the left or right.

- Smooth transition of navigation bar.

- Flexible control mechanism.

## Installation
From CocoaPods ：pod 'XANavBarTransition'.

Manually import：
Drag **XANavBarTransition folder** into your project. 
Import the header file：`#import "XANavBarTransition.h"`.

## Usage

Initialize in the viewDidLoad method of the controller. 

- If you want to change the navigation bar alpha , please set the property `xa_navBarAlpha`，the default is 1.

    `self.xa_navBarAlpha = 0.5;`

- If you need the push feature, please confirm the transition mode and set the transition delegate object, implementation protocol method, the default is left mode.

    ```objc
    - (void)viewDidLoad {
        [super viewDidLoad];
        self.xa_transitionMode     = XATransitionModeRight;
        self.xa_transitionDelegate = self;
    }   
 
    - (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode{
        UIViewController *nextVC = [[UIViewController alloc]init]; 
        return  nextVC;
    }
    ```

- The pop feature is enabled by default. If you want to turn off this feature, set `xa_isPopEnable` property to NO.

    `self.xa_isPopEnable = NO;`

    



See demo for details.

 ![](https://github.com/XangAm/XANavBarTransition/raw/master/bardemo.gif)



## Article
- [iOS 记一次导航栏平滑过渡的实现](https://juejin.im/post/5b9c8002f265da0a8f35b27c)

- [iOS 解决控制器转场的一套方案
  ](https://juejin.im/post/5b9c83fce51d450ea3631ad8)

## Contact

If you have problems during use, please submit an issue to me or [@关于岚](https://weibo.com/daxiec)。Welcome to contact me！
