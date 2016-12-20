//
//  ActivityStepViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepViewController.h"
#import "ActivityStepHeaderView.h"
#import "ActivityDetailTableSectionView.h"
#import "ActivityStepTableCell.h"
#import "ActivityPlayViewController.h"
#import "ShareResourcesViewController.h"
#import "DownloadResourceViewController.h"
#import "CommentPageListViewController.h"
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
    self.title = self.activityStep.title;
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
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ActivityDetailTableSectionView class] forHeaderFooterViewReuseIdentifier:@"ActivityDetailTableSectionView"];
    [self.tableView registerClass:[ActivityStepTableCell class] forCellReuseIdentifier:@"ActivityStepTableCell"];
    self.headerView = [[ActivityStepHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 335 + kTableViewHeaderFixedHeight)];
    self.headerView.activityStep = self.activityStep;
    WEAK_SELF
    [self.headerView setActivityHtmlOpenAndCloseBlock:^(BOOL isStatus) {
        STRONG_SELF
        if (isStatus) {
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + self.headerView.changeHeight);
                self.tableView.tableHeaderView = self.headerView;
                [self.headerView relayoutHtmlText];
            }];
        }else {
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + kTableViewHeaderHtmlPlaceholdeHeight);
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        }
    }];
    [self.headerView setActivityHtmlHeightChangeBlock:^(CGFloat htmlHeight, CGFloat labelHeight) {
        STRONG_SELF
        if (htmlHeight < kTableViewHeaderHtmlPlaceholdeHeight) {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight - kTableViewHeaderOpenAndCloseHeight + htmlHeight + labelHeight);
        }else {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + kTableViewHeaderHtmlPlaceholdeHeight + labelHeight);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        });
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
    view.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    view.contentView.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceilf((float)self.activityStep.tools.count/4.0f);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityStepTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityStepTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.firstTool = [self obtainActivityTool:indexPath.row * 4 + 0];
    cell.secondTool = [self obtainActivityTool:indexPath.row * 4 + 1];
    cell.thirdTool = [self obtainActivityTool:indexPath.row * 4 + 2];
    cell.fourthTool = [self obtainActivityTool:indexPath.row * 4 + 3];
    WEAK_SELF
    [cell setActivityStepTableCellBlock:^(ActivityStepListRequestItem_Body_Active_Steps_Tools *tool) {
        STRONG_SELF
        [self goToNextActivityStepToolContent:tool];
    }];
    return cell;
}

#pragma mark - format data
- (void)goToNextActivityStepToolContent:(ActivityStepListRequestItem_Body_Active_Steps_Tools *)tool {
    if ([tool.toolType isEqualToString:@"video"]) {//视频
        ActivityPlayViewController *VC = [[ActivityPlayViewController alloc] init];
        VC.tool = tool;
        VC.status = self.status;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([tool.toolType isEqualToString:@"discuss"]){//讨论
        CommentPageListViewController *VC = [[CommentPageListViewController alloc] init];
        VC.tool = tool;
        VC.status = self.status;
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([tool.toolType isEqualToString:@"resdisc"]) {//资源下载
        DownloadResourceViewController *downloadVc = [[DownloadResourceViewController alloc]init];
        downloadVc.status = self.status;
        downloadVc.tool = tool;
        [self.navigationController pushViewController:downloadVc animated:YES];
    } else if ([tool.toolType isEqualToString:@"resources"]) {//资源分享
        ShareResourcesViewController *shareResourceVC = [[ShareResourcesViewController alloc]init];
        shareResourceVC.status = self.status;
        shareResourceVC.tool = tool;
        [self.navigationController pushViewController:shareResourceVC animated:YES];
    } else {
        [self showToast:@"暂不支持该类型的工具"];
    }
}
- (ActivityStepListRequestItem_Body_Active_Steps_Tools *)obtainActivityTool:(NSInteger)integer {
    if (self.activityStep.tools.count > integer) {
        return self.activityStep.tools[integer];
    }else {
        return nil;
    }
}
@end
