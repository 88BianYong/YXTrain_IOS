//
//  YXScoreTypeCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreTypeHeaderView.h"

@interface YXScoreTypeHeaderView()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXScoreTypeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeImageView.mas_centerY);
    }];
}

- (void)setType:(YXScoreHeaderViewType)type{
    _type = type;
    if (type == YXScoreHeaderViewType_Lead) {
        self.typeImageView.image = [UIImage imageNamed:@"引领"];
        self.titleLabel.text = @"引领学习";
    }else{
        self.typeImageView.image = [UIImage imageNamed:@"拓展"];
        self.titleLabel.text = @"拓展学习";
    }
}

@end
