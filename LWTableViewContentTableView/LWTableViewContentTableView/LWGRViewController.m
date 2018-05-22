//
//  LWGRViewController.m
//  LWTableViewContentTableView
//
//  Created by liwei on 2018/5/22.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "LWGRViewController.h"
#import "LWGRBaseTableViewController.h"
#import "LWGRTableView.h"
#import "LWTestViewController1.h"
// ==========================================================================================================================================
#pragma mark - 定义滚动视图控制器
@interface LWGRViewController ()

/** 列表视图 */
@property (nonatomic,strong) LWGRTableView *tableView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滚动 */
@property (nonatomic,assign) BOOL canScroll;
/** 偏移Y */
@property (nonatomic,assign) CGFloat offset_y;
/** 头部视图 */
@property (nonatomic,strong) UIView *header;
/** 标题视图 */
@property (nonatomic,strong) UIView * itemView;

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动视图控制器tools
@interface LWGRViewController (tools)

- (void)addViewSubviews;    // 添加子控件
- (void)layoutViewSubviews; // 布局子控件
- (void)changeVCScrollState;// 改变滚动状态

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动视图控制器UITableViewDataSourceDelegate
@interface LWGRViewController (UITableViewDataSourceDelegate)<UITableViewDataSource,UITableViewDelegate>
@end
// ==========================================================================================================================================
#pragma mark - 定义滚动视图控制器
@implementation LWGRViewController

- (LWGRTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[LWGRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.tag = 999;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)header {
    if (_header == nil) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        _header.backgroundColor = [UIColor redColor];
    }
    return _header;
}

- (UIView *)itemView {
    if (_itemView == nil) {
        _itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
        _itemView.backgroundColor = [UIColor blueColor];
    }
    return _itemView;
}

#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewSubviews];
}
#pragma mark 重写viewWillLayoutSubviews
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutViewSubviews];
}
#pragma mark 重写viewWillAppear:
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kScrollStateNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVCScrollState) name:kScrollStateNotify object:nil];
}
#pragma mark 重写viewWillDisappear:
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kScrollStateNotify object:nil];
}

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动视图控制器tools
@implementation LWGRViewController (tools)



#pragma mark - 添加子控件
- (void)addViewSubviews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.canScroll = YES;
    self.tableView.tableHeaderView = self.header;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
#pragma mark - 布局子控件
- (void)layoutViewSubviews {
    self.tableView.frame = self.view.bounds;
}
#pragma mark - 改变滚动状态
- (void)changeVCScrollState {
    self.canScroll = YES;
    for (int i = 0; i < self.childVCs.count; i++) {
        LWGRBaseTableViewController *vc = self.childVCs[i];
        vc.vcCanScroll = NO;
    }
}

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动视图控制器UITableViewDataSourceDelegate
@implementation LWGRViewController (UITableViewDataSourceDelegate)

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"LWViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat w = tableView.frame.size.width;
    CGFloat h = self.header.frame.size.height;
    h = self.itemView.frame.size.height;
    self.itemView.frame = CGRectMake(x, y, w, h);
    [cell.contentView addSubview:self.itemView];
    
    y = CGRectGetMaxY(self.itemView.frame);
    h = tableView.frame.size.height - y;
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    LWTestViewController1 *vc = [[LWTestViewController1 alloc] init];
    vc.view.frame = sc.bounds;
    [sc addSubview:vc.view];
    [self addChildViewController:vc];
    [cell.contentView addSubview:sc];
    self.childVCs = @[vc];
    return cell;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 999) {
        self.offset_y = scrollView.contentOffset.y;
        NSLog(@"offset_y = %f",self.offset_y);
        /* 关键 */
        CGFloat headerOffset = self.header.frame.size.height;
        
        if (self.offset_y >= headerOffset) {
            scrollView.contentOffset = CGPointMake(0, headerOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (int i = 0; i < self.childVCs.count; i++) {
                    LWGRBaseTableViewController *vc = self.childVCs[i];
                    vc.vcCanScroll = YES;
                }
            }
        }
        else {
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, headerOffset);
            }
        }
        self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
    }
}

@end
//==========================================================================================================================================
