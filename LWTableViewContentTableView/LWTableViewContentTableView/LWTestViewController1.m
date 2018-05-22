//
//  LWTestViewController1.m
//  LWTableViewContentTableView
//
//  Created by liwei on 2018/5/22.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "LWTestViewController1.h"
//#import "MJRefresh.h"
// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器测试控制器1
@interface LWTestViewController1 ()


@property (nonatomic,assign) NSInteger   count;

@end
// ==========================================================================================================================================
#pragma mark - 定义滚动识别多个手势列表视图控制器测试控制器1
@implementation LWTestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _count = 25;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"LWTestViewController1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"LWTestViewController(%ld)",(long)indexPath.row];
//    cell.contentView.backgroundColor = [UIColor greenColor];
    return cell;
}

@end
// ==========================================================================================================================================

