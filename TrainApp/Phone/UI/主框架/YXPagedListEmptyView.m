
//
//  YXPagedListEmptyView.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXPagedListEmptyView.h"

@interface YXPagedListEmptyView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation YXPagedListEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.textLabel.text = title;
}

- (void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        _textLabel.textColor = [UIColor colorWithHexString:@"dfe2e6"];
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(@0);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(@10);
        }];
    }
    return _textLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(@-30.f);
            make.centerX.mas_equalTo(@0);
        }];
    }
    return _iconImageView;
}

@end
