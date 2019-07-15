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


/*
 
 
 
 import UIKit
 
 class CPGDViewController: CPBaseViewController {
 
 
 /// 头部视图
 lazy var headerView: UIView = {
 let view = UIView()
 view.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 100)
 view.backgroundColor = .red
 return view
 }()
 
 // MARK: 列表视图
 /// 列表视图GRTableView
 lazy var tableView: CPGRTableView = {
 let view = CPGRTableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
 view.backgroundColor = UIColor.clear
 view.separatorStyle = .none
 view.delegate = self
 view.dataSource = self
 view.tag = 999
 view.showsVerticalScrollIndicator = false
 view.showsHorizontalScrollIndicator = false
 return view
 }()
 // MARK: 子控制器数组
 var childViews = [CPGRView]()
 // MARK: 是否可以滚动
 var canScroll = true
 var offset_y = 0.0
 
 // MARK: 标题视图
 /// 标题视图
 lazy var itemView: CPTitleNavView = {
 let view = CPTitleNavView()
 view.backgroundColor = .white
 //        view.delegate = self
 view.titleColor = UIColor.black
 view.titleSelectColor = UIColor.red
 view.lineBottomMargin = 0.0
 view.titleFont = UIFont.systemFont(ofSize: 15.0)
 view.titleSelectFont = UIFont.systemFont(ofSize: 15.0)
 view.titleArray = ["热门跟单","人气跟单","我的关注"]
 view.allLineColor = UIColor.lightGray
 return view
 }()
 /// 固定选项组
 var itemViewAdjective = false
 override func viewDidLoad() {
 super.viewDidLoad()
 addViewSubviews()
 }
 override func viewWillLayoutSubviews() {
 super.viewWillLayoutSubviews()
 self.tableView.frame = self.view.bounds;
 }
 // MARK: - 重写viewWillAppear
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 CPAddNotification(self, selector: #selector(changeVCScrollState), NotificationName: kScrollStateNotify)
 
 }
 // MARK: - 重写viewWillDisappear
 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(animated)
 CPRemoveNotification(self, NotificationName: kScrollStateNotify)
 }
 deinit {
 CPRemoveNotification(self, NotificationName: kScrollStateNotify)
 }
 @objc func changeVCScrollState() {
 self.canScroll = true
 for index in 0..<childViews.count {
 let childView = childViews[index]
 childView.vcCanScroll = false
 }
 }
 
 }
 // =================================================================================================================================
 // MARK: - 跟单视图控制器
 extension CPGDViewController {
 /// 添加子控件
 //MARK: - 添加子控件
 func addViewSubviews() {
 if #available(iOS 11.0, *) {
 tableView.contentInsetAdjustmentBehavior = .never
 } else {
 self.automaticallyAdjustsScrollViewInsets = false
 }
 tableView.estimatedSectionHeaderHeight = 0.0
 tableView.estimatedSectionFooterHeight = 0.0
 self.canScroll = true
 self.tableView.tableHeaderView = headerView;
 self.view.addSubview(self.tableView)
 tableView.reloadData()
 }
 }
 // =================================================================================================================================
 // MARK: - 跟单视图控制器UITableViewDelegateDataSource
 extension CPGDViewController :UITableViewDelegate, UITableViewDataSource {
 
 /// cell数量
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return 1
 }
 // MARK: cell高度
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
 return tableView.frame.size.height
 }
 // MARK: cell样式
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let identifier = "CPViewController"
 var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
 if cell == nil {
 cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
 cell?.backgroundColor = .white
 cell?.selectionStyle = .none
 }
 
 var x :CGFloat = 0.0
 var y :CGFloat = 0.0
 var w :CGFloat = tableView.frame.size.width
 var h :CGFloat = 44.0
 
 self.itemView.frame = CGRect.init(x: x, y: y, width: w, height: h)
 itemView.cellWidth = itemView.frame.size.width / CGFloat(self.itemView.titleArray.count)
 itemView.showView()
 cell?.contentView.addSubview(self.itemView)
 
 y = self.itemView.frame.maxY;
 h = tableView.frame.size.height - y;
 let sc = UIScrollView.init(frame: CGRect.init(x: x, y: y, width: w, height: h))
 sc.backgroundColor = UIColor.lightGray
 cell?.contentView.addSubview(sc)
 let vc = CPGRView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: w, height: h))
 vc.backgroundColor = UIColor.white
 sc.addSubview(vc)
 childViews.append(vc)
 let vc1 = CPGRView.init(frame: CGRect.init(x: w, y: 0.0, width: w, height: h))
 vc1.backgroundColor = UIColor.blue
 sc.addSubview(vc1)
 childViews.append(vc1)
 sc.contentSize = CGSize.init(width: w * CGFloat(childViews.count), height: h)
 return cell!
 }
 // MARK: 选择cell
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 tableView.deselectRow(at: indexPath, animated: false)
 }
 
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 
 if (scrollView.tag == 999) {
 let contentOffsetY :CGFloat = scrollView.contentOffset.y
 /* 关键 */
let headerOffset = self.headerView.frame.size.height;

if (contentOffsetY >= headerOffset) {
    scrollView.contentOffset = CGPoint.init(x: 0, y: headerOffset)
    if (self.canScroll) {
        self.canScroll = false;
        canScroll = false
        for index in 0..<childViews.count {
            let childView = childViews[index]
            childView.vcCanScroll = true
        }
    }
    }
    else {
        if (!self.canScroll) {
            scrollView.contentOffset = CGPoint.init(x: 0, y: headerOffset)
        }
    }
    self.tableView.showsVerticalScrollIndicator = false
    }

}

}

 
 */

//==========================================================================================================================================
