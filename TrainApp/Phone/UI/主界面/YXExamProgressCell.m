//
//  YXExamProgressCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamProgressCell.h"
#import "YXExamProgressView.h"
#import "YXExamHelper.h"

@interface YXExamProgressCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
@property (nonatomic, strong) UIButton *markButton;
@end

@implementation YXExamProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.typeImageView = [[UIImageView alloc]init];
//    self.typeImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.progressView = [[YXExamProgressView alloc]init];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
//        make.centerY.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(-2);
        make.height.mas_equalTo(6);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(8);
    }];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont systemFontOfSize:11];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_left);
        make.right.mas_equalTo(self.progressView.mas_right);
        make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-11);
    }];
    [self.progressLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.progressLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    self.markButton = [[UIButton alloc]init];
//    self.markButton.backgroundColor = [UIColor redColor];
    [self.markButton setImage:[UIImage imageNamed:@"点评icon"] forState:UIControlStateNormal];
    [self.markButton setImage:[UIImage imageNamed:@"点评icon-点击态"] forState:UIControlStateHighlighted];
    [self.markButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setItem:(YXExamineRequestItem_body_toolExamineVo *)item{
    _item = item;
    self.titleLabel.text = item.name;
    self.progressLabel.attributedText = [YXExamHelper toolCompleteStatusStringWithID:item.toolid finishNum:item.finishnum totalNum:item.totalnum];
    CGFloat progress = item.finishnum.floatValue/item.totalnum.floatValue;
    self.progressView.progress = progress;
    [self.markButton removeFromSuperview];
    if (item.isneedmark.boolValue) {
        [self.contentView addSubview:self.markButton];
        [self.markButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressView.mas_right);
            make.centerY.mas_equalTo(self.progressLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.progressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.progressView.mas_left);
            make.right.mas_equalTo(self.markButton.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-11);
        }];
    }else{
        [self.progressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.progressView.mas_left);
            make.right.mas_equalTo(self.progressView.mas_right);
            make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-11);
        }];
    }
    
    if (item.toolid.integerValue == 201 || item.toolid.integerValue == 301) {
        self.typeImageView.image = [UIImage imageNamed:@"课程"];
    }else if (item.toolid.integerValue == 202 || item.toolid.integerValue == 302){
        self.typeImageView.image = [UIImage imageNamed:@"活动"];
    }else if (item.toolid.integerValue == 203 || item.toolid.integerValue == 303){
        self.typeImageView.image = [UIImage imageNamed:@"作业"];
    }else if (item.toolid.integerValue == 216 || item.toolid.integerValue == 316){
        self.typeImageView.image = [UIImage imageNamed:@"小组作业icon"];
    }else if (item.toolid.integerValue == 218 || item.toolid.integerValue == 318){
        self.typeImageView.image = [UIImage imageNamed:@"线下活动icon"];
    }else if (item.toolid.integerValue == 219 || item.toolid.integerValue == 319){
        self.typeImageView.image = [UIImage imageNamed: @"作业互评icon"];
    }else if (item.toolid.integerValue == 221 || item.toolid.integerValue == 321){
        self.typeImageView.image = [UIImage imageNamed: @"随堂练icon"];
    }else {
        self.typeImageView.image = nil;
    }
}

- (void)btnAction:(UIButton *)sender{
    BLOCK_EXEC(self.markAction,sender);
}

@end
