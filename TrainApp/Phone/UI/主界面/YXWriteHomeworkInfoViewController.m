//
//  YXWriteHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController.h"
#import "YXWriteHomeworkInfoHeaderView.h"
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
    [self layoutInterface];
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
//    [_tableView registerClass:[YXWriteHomeworkInfoHeaderView class] forCellReuseIdentifier:@"YXWriteHomeworkInfoHeaderView"];
    [_tableView registerClass:[YXWriteHomeworkInfoHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXWriteHomeworkInfoHeaderView"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];

}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXWriteHomeworkInfoHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXWriteHomeworkInfoHeaderView"];
    return view;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end
