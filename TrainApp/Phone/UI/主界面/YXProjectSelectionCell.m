//
//  YXProjectSelectionCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectSelectionCell.h"

@interface YXProjectSelectionCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXProjectSelectionCell

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
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setName:(NSString *)name{
    _name = name;
    self.titleLabel.text = name;
}

- (void)setIsCurrent:(BOOL)isCurrent{
    _isCurrent = isCurrent;
    if (isCurrent) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }else{
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
}

@end
