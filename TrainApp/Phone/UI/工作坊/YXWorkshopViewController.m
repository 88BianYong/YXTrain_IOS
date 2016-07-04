//
//  YXWorkshopViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopViewController.h"
#import "YXWorkshopCell.h"
@interface YXWorkshopViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
}
@end

@implementation YXWorkshopViewController
- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的工作坊";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupUI];
    [self layoutInterface];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 26, 0, 0);
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [_tableView registerClass:[YXWorkshopCell class] forCellReuseIdentifier:@"YXWorkshopCell"];
    [self.view addSubview:_tableView];
}
- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(5.0f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXWorkshopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopCell"
                                                           forIndexPath:indexPath];
    [cell reloadWithText:@"你好不好呀 就是不好 的书法家" imageUrl:@""];
    return cell;
}


@end
