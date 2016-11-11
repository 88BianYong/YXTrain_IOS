//
//  ActivityCommentTableView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityCommentTableView.h"
#import "ActitvityCommentHeaderView.h"
#import "ActitvityCommentCell.h"
#import "ActitvityCommentFooterView.h"
@interface ActivityCommentTableView()<UITableViewDelegate, UITableViewDataSource>
@end
@implementation ActivityCommentTableView
- (void)dealloc {
    DDLogDebug(@"release====>>%@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.clipsToBounds = YES;
        [self setupMorkData];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 44.0f;
    self.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = 44.0f;
    [self registerClass:[ActitvityCommentCell class] forCellReuseIdentifier:@"ActitvityCommentCell"];
    [self registerClass:[ActitvityCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"ActitvityCommentHeaderView"];
    [self registerClass:[ActitvityCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"ActitvityCommentFooterView"];
}
- (void)setupMorkData {
   ActivityFirstCommentRequestItem_Body *body = [[ActivityFirstCommentRequestItem_Body alloc] init];
    ActivityFirstCommentRequestItem_Body_Replies *replie = [[ActivityFirstCommentRequestItem_Body_Replies alloc] init];
    replie.headUrl = @"http://s1.jsyxw.cn/yanxiu/u/32/81/Img828132_60.jpg";
    replie.time = @"2016年11月09日 13:54";
    replie.userName = @"李四";
    replie.up = @"5";
    replie.childNum = @"5";
    replie.content = @"是分开了涉及到法律会计师的两款发动机谁离开就疯了空间上浪费的空间个";
    NSMutableArray<ActivityFirstCommentRequestItem_Body_Replies> *mutableArray = [@[replie,replie,replie,replie,replie] mutableCopy];
    replie.reply = mutableArray;
    body.replies = mutableArray;
    self.dataMutableArray = body.replies;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    return replie.reply.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[indexPath.section];
    ActivityFirstCommentRequestItem_Body_Replies *reply = replie.reply[indexPath.row];
    ActitvityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActitvityCommentCell" forIndexPath:indexPath];
    cell.reply = reply;
    if (cell.reply.childNum.integerValue <= 1) {
        cell.cellStatus = ActitvityCommentCellStatus_Top | ActitvityCommentCellStatus_Bottom;
    }else {
        if (indexPath.row == 0) {
            cell.cellStatus = ActitvityCommentCellStatus_Top;
        } else if ((replie.childNum.integerValue == reply.reply.count) && (indexPath.row == reply.reply.count - 1)) {
            cell.cellStatus = ActitvityCommentCellStatus_Bottom;
        } else {
            cell.cellStatus = ActitvityCommentCellStatus_Middle;
        }
    }
    return cell;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    ActitvityCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentHeaderView"];
    headerView.replie = replie;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ActitvityCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 29.0f;
}

@end
