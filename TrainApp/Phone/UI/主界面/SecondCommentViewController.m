//
//  SecondCommentViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "SecondCommentViewController.h"
#import "CommentPagedListFetcher.h"
#import "ActitvityCommentHeaderView.h"
#import "ActitvityCommentCell.h"
#import "ActitvityCommentFooterView.h"
#import "SecondCommentFooterView.h"
#import "UITableView+TemplateLayoutHeaderView.h"
@interface SecondCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SecondCommentViewController
- (void)dealloc {
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部回复";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.dataFetcher = [[CommentPagedListFetcher alloc] init];
    self.dataFetcher.aid = self.tool.aid;
    self.dataFetcher.toolid = self.tool.toolid;
    self.dataFetcher.w = [YXTrainManager sharedInstance].currentProject.w;
    self.dataFetcher.pageIndex = 1;
    self.dataFetcher.pageSize = 20;
    self.dataFetcher.parentid = self.parentID;
    self.isHiddenInputView = YES;
    [super setupUI];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SecondCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"SecondCommentFooterView"];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActitvityCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentHeaderView"];
    if (section == 0) {
        headerView.replie = self.replie;
        headerView.isFontBold = YES;
    }else {
        ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
        headerView.replie = replie;
        headerView.isFontBold = NO;
    }
    headerView.distanceTop = kDistanceTopShort;
    WEAK_SELF
    [headerView setActitvityCommentFavorBlock:^{
        STRONG_SELF
        if ([self isCheckActivityStatus]) {
            [self requestForCommentLaud:[NSString stringWithFormat:@"%ld",(long)section]];
        }
    }];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    WEAK_SELF
    return [tableView yx_heightForCellWithIdentifier:@"ActitvityCommentHeaderView" configuration:^(ActitvityCommentHeaderView *header) {
        STRONG_SELF
        if (section == 0) {
            header.isFontBold = YES;
            header.replie = self.replie;
        }else {
            ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
            header.isFontBold = NO;
            header.replie = replie;
        }
        header.distanceTop = kDistanceTopShort;
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        SecondCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SecondCommentFooterView"];
        footerView.replyNumber = self.totalNum;
        return footerView;
    }else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 30.0f;
    }else {
        return 0.0001f;
    }
}
- (void)formatCommentContent{
    [self.dataMutableArray insertObject:self.replie atIndex:0];
}
@end
