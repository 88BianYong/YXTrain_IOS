//
//  YXMyDatumNormalInfoView.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyDatumNormalInfoView.h"

@implementation YXMyDatumNormalInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.typeImageView];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.dateLabel];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.sizeLabel];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeImageView);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeImageView);
        make.right.mas_lessThanOrEqualTo(self);
    }];
    
}

@end
