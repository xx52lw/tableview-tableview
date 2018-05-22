//
//  LWGRBaseTableViewController.h
//  LWTableViewContentTableView
//
//  Created by liwei on 2018/5/22.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *kScrollStateNotify = @"LWGRBaseTableViewControllerScrollState";
// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器基类
@interface LWGRBaseTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

/** 是否可以滚动 */
@property (nonatomic, assign) BOOL vcCanScroll;
/** 列表视图 */
@property (nonatomic,strong) UITableView *tableView;

@end
// ==========================================================================================================================================
