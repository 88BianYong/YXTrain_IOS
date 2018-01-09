//
//  MasterMessageViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterMessageViewController_17.h"
#import "YXMessageCell_17.h"
#import "YXSectionHeaderFooterView.h"
@interface MasterMessageViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@end

@implementation MasterMessageViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@{@"title":@"热点",@"normalIcon":@"热点icon-正常态",@"hightIcon":@"热点icon-点击态"},@{@"title":@"消息动态",@"normalIcon":@"消息",@"hightIcon":@"消息点击"}/*,@{@"title":@"私信坊主",@"normalIcon":@"私信",@"hightIcon":@"私信点击"}*/];
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [LSTSharedInstance sharedInstance].redPointManger.hotspotInteger = -1;
        [[LSTSharedInstance  sharedInstance].webSocketManger setState:YXWebSocketMangerState_Hotspot];
        UIViewController *VC = [[NSClassFromString(@"YXHotspotViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section == 1) {
        UIViewController *VC = [[NSClassFromString(@"MasterDynamicViewController_17") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section == 2) {
        
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMessageCell_17 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YXMessageCell_17" forIndexPath:indexPath];
    cell.nameDictionary = self.titleArray[indexPath.section];
    cell.cellStatus = indexPath.section;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5.0f;
    }
    return 0.0001f;
}
@end
