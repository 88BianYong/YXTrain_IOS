//
//  ActivityStepViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepViewController.h"
#import "ActivityStepCollectionCell.h"
#import "ActivityStepHeaderView.h"
#import "ActivityDetailTableSectionView.h"
#import "ActivityStepTableCell.h"
@interface ActivityStepViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityStepHeaderView *headerView;

@end

@implementation ActivityStepViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"步骤详情";
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ActivityDetailTableSectionView class] forHeaderFooterViewReuseIdentifier:@"ActivityDetailTableSectionView"];
    [self.tableView registerClass:[ActivityStepTableCell class] forCellReuseIdentifier:@"ActivityStepTableCell"];
    self.headerView = [[ActivityStepHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125 + 300.0)];
    self.headerView.activity = nil;
    WEAK_SELF
    [self.headerView setActivityHtmlOpenAndCloseBlock:^(BOOL isStatus) {
        STRONG_SELF
        if (isStatus) {
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 125.0f + self.headerView.htmlHeight);
                self.tableView.tableHeaderView = self.headerView;
                [self.headerView relayoutHtmlText];
            }];
        }else {
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 125.0f + 300.0f);
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        }
    }];
    [self.headerView setActivityHtmlHeightChangeBlock:^(BOOL height) {
        STRONG_SELF
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 325.0f + self.headerView.htmlHeight);
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView relayoutHtmlText];
    }];
    self.tableView.tableHeaderView = self.headerView;
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 73.0f;
    }else {
        return 15.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ActivityDetailTableSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActivityDetailTableSectionView"];
    view.titleString = @"步骤工具";
    view.contentView.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *string = @"ActivityPlayViewController";
    UIViewController *VC = [[NSClassFromString(string) alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityStepTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityStepTableCell" forIndexPath:indexPath];
    return cell;
}
@end
