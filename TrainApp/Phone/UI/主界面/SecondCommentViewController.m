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
@interface SecondCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SecondCommentViewController
- (void)dealloc {
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
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
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    ActitvityCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentHeaderView"];
    headerView.replie = replie;
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        SecondCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SecondCommentFooterView"];
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
@end
