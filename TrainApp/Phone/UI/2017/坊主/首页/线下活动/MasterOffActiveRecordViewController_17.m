//
//  MasterOffActiveRecordViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveRecordViewController_17.h"
#import "MasterOffActiveRecordAffixCell_17.h"
#import "MasterOffActiveRecordHeaderView_17.h"
@interface MasterOffActiveRecordViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, copy) NSString *wonderfulString;
@property (nonatomic, strong) NSArray *affixArray;

@end

@implementation MasterOffActiveRecordViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 150.0f;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MasterOffActiveRecordAffixCell_17 class] forCellReuseIdentifier:@"MasterOffActiveRecordAffixCell_17"];
    [self.tableView registerClass:[MasterOffActiveRecordHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterOffActiveRecordHeaderView_17"];
    
    
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.affixArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterOffActiveRecordAffixCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterOffActiveRecordAffixCell_17" forIndexPath:indexPath];
    cell.affix = self.affixArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterOffActiveRecordHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterOffActiveRecordHeaderView_17"];
    headerView.contentString = self.wonderfulString?:@"";
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)reloadMasterOffActiveRecord:(NSString *)wonderful withAffix:(NSArray *)affixs {
    self.wonderfulString = wonderful;
    self.affixArray = affixs;
    [self.tableView reloadData];
}
@end
