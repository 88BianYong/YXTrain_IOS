//
//  YXTrainListViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/4/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXTrainListViewController.h"
#import "YXTrainListChooseCell.h"
@interface YXTrainListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@end

@implementation YXTrainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self setupNavgationLeftView];
    if (self.isLoginChooseBool) {
        self.title = @"选择项目";
    }else {
        self.title = [LSTSharedInstance sharedInstance].trainManager.currentProject.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0.0f;
    self.tableView.rowHeight = 150.0f;
    self.tableView.estimatedSectionHeaderHeight = 0.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.estimatedSectionFooterHeight = 0.0f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXTrainListChooseCell class] forCellReuseIdentifier:@"YXTrainListChooseCell"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setupNavgationLeftView {
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [cancleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cancleButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    WEAK_SELF
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        if (self.isLoginChooseBool) {
            [self dismissViewControllerAnimated:NO completion:^{
                [[LSTSharedInstance sharedInstance].userManger logout];
                [YXDataStatisticsManger trackEvent:@"退出登录" label:@"成功登出" parameters:nil];
            }];
        }else {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];
    [self setupLeftWithCustomView:cancleButton];
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXTrainListChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXTrainListChooseCell" forIndexPath:indexPath];
    cell.train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains[indexPath.section];
    if (!self.isLoginChooseBool && [LSTSharedInstance sharedInstance].trainManager.currentProjectIndex == indexPath.section) {
        cell.isChooseBool = YES;
    }else {
        cell.isChooseBool = NO;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXTrainListRequestItem_body_train *train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains[indexPath.section];
    if(self.isLoginChooseBool) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainChoosePid];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[LSTSharedInstance sharedInstance].trainManager setupProjectId:train.pid];
    }else if ([LSTSharedInstance sharedInstance].trainManager.currentProject.pid.integerValue !=
        train.pid.integerValue) {
        [[LSTSharedInstance sharedInstance].trainManager setupProjectId:train.pid];
        BLOCK_EXEC(self.reloadChooseTrainListBlock);
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
