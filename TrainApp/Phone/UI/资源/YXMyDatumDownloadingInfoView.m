//
//  YXMyDatumDownloadingInfoView.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyDatumDownloadingInfoView.h"

@implementation YXMyDatumDownloadingInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.downloadingLabel = [[UILabel alloc]init];
    self.downloadingLabel.font = [UIFont systemFontOfSize:10];
    self.downloadingLabel.textColor = [UIColor colorWithHexString:@"2c97dd"];
    [self addSubview:self.downloadingLabel];
    
    self.downloadProgressLabel = [[UILabel alloc]init];
    self.downloadProgressLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.downloadProgressLabel];
    
    [self.downloadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    
    [self.downloadProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.downloadingLabel.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(self.downloadingLabel.mas_centerY);
        make.right.mas_lessThanOrEqualTo(0);
    }];
}

@end
