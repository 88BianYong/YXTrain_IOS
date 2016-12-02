//
//  BeijingCheckedMobileUserHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCheckedMobileUserHeaderView.h"
@interface BeijingCheckedMobileUserHeaderView ()
@property (nonatomic, strong) UILabel *passportLabel;
@end

@implementation BeijingCheckedMobileUserHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"a1a3a6"];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"继教编号";
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(45.0f);
    }];
    
    self.passportLabel = [[UILabel alloc] init];
    self.passportLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.passportLabel.font = [UIFont systemFontOfSize:15.0f];
    self.passportLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.passportLabel];
    
    [self.passportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(9.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)setPassportString:(NSString *)passportString {
    _passportString = passportString;
    self.passportLabel.text = _passportString;
}
@end
