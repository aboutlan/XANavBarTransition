//
//  SecondViewController.m
//  demo_导航栏平滑过渡
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "XANavBarTransition.h"
#import "CommonDefine.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,XATransitionDelegate>
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup{
    XA_ADJUSTS_SCROLLVIEW_INSETS(self.tableView);

    self.title = @"2";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.xa_navBarAlpha = 0;
    self.xa_transitionMode = XATransitionModeLeft;
    self.xa_transitionDelegate = self;
}


#pragma mark -<UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"cell:indexPath:%ld",(long)indexPath.row];
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY > 0){
        self.xa_navBarAlpha = (offsetY - 50 ) / 150;
        [self.navigationController xa_changeNavBarAlpha:self.xa_navBarAlpha];
    }
}

#pragma mark - <XATransitionDelegate>
- (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode{
    ThirdViewController *thirdVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ThirdViewController class])];
    return thirdVC;
}


@end
