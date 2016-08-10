//
//  YXWriteHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController.h"
@interface YXWriteHomeworkInfoViewController()
<
  UITableViewDelegate,
  UITableViewDataSource
>
{
    UITableView *_tableView;
}
@end
@implementation YXWriteHomeworkInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"填写作业信息";
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
//    [_tableView registerClass:[YXHomeworkListCell class] forCellReuseIdentifier:@"YXHomeworkListCell"];
//    [_tableView registerClass:[YXHomeworkListHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXHomeworkListHeaderView"];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
//    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];

}

- (void)layoutInterface{
    
}
@end
