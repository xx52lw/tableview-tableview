//
//  LWGRBaseTableViewController.m
//  LWTableViewContentTableView
//
//  Created by liwei on 2018/5/22.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "LWGRBaseTableViewController.h"
// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器基类
@interface LWGRBaseTableViewController ()

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器基类tools
@interface LWGRBaseTableViewController (tools)

- (void)addViewSubviews;    // 添加子控件

@end

// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器基类
@implementation LWGRBaseTableViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewSubviews];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
     self.tableView.frame = self.view.bounds;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWGRBaseTableViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LWGRBaseTableViewController"];
    }
    return cell;
}
#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (!self.vcCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.vcCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:kScrollStateNotify object:nil userInfo:nil];//到顶通知父视图改变状态
        }
        self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
    }
}

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器基类tools
@implementation LWGRBaseTableViewController (tools)

#pragma mark - 添加子控件
- (void)addViewSubviews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
}

@end
// ==========================================================================================================================================
