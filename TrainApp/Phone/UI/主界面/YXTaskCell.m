//
//  YXTaskCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTaskCell.h"

@interface YXTaskCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation YXTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.enterImageView.image = [UIImage imageNamed:@"课程进入列表箭头-点击态"];
    }else{
        self.enterImageView.image = [UIImage imageNamed:@"课程进入列表箭头"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.centerY.mas_equalTo(0);
    }];
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self.typeImageView.mas_centerY);
    }];
    self.enterImageView = [[UIImageView alloc]init];
//    self.enterImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.mas_equalTo(self.typeImageView.mas_centerY);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTask:(YXTaskListRequestItem_body_task *)task{
    _task = task;
    self.typeLabel.text = task.name;
    if (task.toolid.integerValue == 201 || task.toolid.integerValue == 203) {  // 课程 || 作业
        self.typeLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.enterImageView.hidden = NO;
    }else{
        self.typeLabel.textColor = [UIColor colorWithHexString:@"bec8d8"];
        self.enterImageView.hidden = YES;
    }
    // images setting
    if (task.toolid.integerValue == 201) {
        self.typeImageView.image = [UIImage imageNamed:@"课程icon"];
    }else if (task.toolid.integerValue == 202){
        self.typeImageView.image = [UIImage imageNamed:@"活动icon"];
    }else if (task.toolid.integerValue == 203){
        self.typeImageView.image = [UIImage imageNamed:@"作业icon"];
    }else if (task.toolid.integerValue == 209){
        self.typeImageView.image = [UIImage imageNamed:@"日志icon"];
    }else if (task.toolid.integerValue == 210){
        self.typeImageView.image = [UIImage imageNamed:@"资源"];
    }else if (task.toolid.integerValue == 211){
        self.typeImageView.image = [UIImage imageNamed:@"问答icon"];
    }else{
        self.typeImageView.image = nil;
    }
}

@end
