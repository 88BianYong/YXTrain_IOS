//
//  YXScoreBounsGroupCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreExpGroupCell.h"
#import "YXScoreExpHeaderView.h"
#import "YXScoreExpScoreCell.h"
#import "YXSectionHeaderFooterView.h"
@implementation YXExpSubItem
@end
@implementation YXExpItem
@end

@interface YXScoreExpGroupCell()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic ,strong)UITableView *tableView;
@end
@implementation YXScoreExpGroupCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - setupUI
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.tableView registerClass:[YXScoreExpScoreCell class] forCellReuseIdentifier:@"YXScoreExpScoreCell"];
    [self.tableView registerClass:[YXScoreExpHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXScoreExpHeaderView"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.subItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXScoreExpScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreExpScoreCell"];
    YXExpSubItem *item = self.data.subItemArray[indexPath.row];
    cell.title = item.name;
    cell.score = item.score;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXScoreExpHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXScoreExpHeaderView"];
    header.title = self.data.name;
    header.score = self.data.score;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXSectionHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

#pragma mark - format Data

@end
