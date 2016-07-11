//
//  YXExamEndDateCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamEndDateCell.h"

@interface YXExamEndDateCell()
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation YXExamEndDateCell

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
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"d1d1d1"];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self.contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dateLabel.mas_centerY);
        make.right.mas_equalTo(self.dateLabel.mas_left).mas_offset(-10);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.width.mas_equalTo(36);
    }];
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self.contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dateLabel.mas_centerY);
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.width.mas_equalTo(36);
    }];
}

- (void)setDate:(NSString *)date{
    _date = date;
    self.dateLabel.text = [NSString stringWithFormat:@"结束日期：%@",date];
}

@end
