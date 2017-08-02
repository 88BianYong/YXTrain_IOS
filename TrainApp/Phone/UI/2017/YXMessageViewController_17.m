//
//  XYMessageViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMessageViewController_17.h"
#import "YXMessageCell_17.h"
#import "YXSectionHeaderFooterView.h"
@interface YXMessageViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@end

@implementation YXMessageViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@{@"title":@"热点",@"normalIcon":@"热点icon-正常态",@"hightIcon":@"热点icon-点击态"},
                    @{@"title":@"消息动态",@"normalIcon":@"消息动态icon-正常态",@"hightIcon":@"消息动态icon-点击态"}/*,
                    @{@"title":@"私信坊主",@"normalIcon":@"私信",@"hightIcon":@"私信点击"}*/];
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI
- (void)setupUI {
    self.title = @"消息";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.001f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXMessageCell_17 class] forCellReuseIdentifier:@"YXMessageCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.view addSubview:self.tableView];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIViewController *VC = [[NSClassFromString(@"YXHotspotViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1) {
        UIViewController *VC = [[NSClassFromString(@"YXDynamicViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 2) {
        
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMessageCell_17 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YXMessageCell_17" forIndexPath:indexPath];
    cell.nameDictionary = self.titleArray[indexPath.row];
    return cell;
}
@end
