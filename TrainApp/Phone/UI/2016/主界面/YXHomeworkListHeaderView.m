//
//  YXHomeworkListHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkListHeaderView.h"
@interface YXHomeworkListHeaderView()
{
    UILabel *_titleLabel;
    CAShapeLayer *_maskLayer;
}
@end

@implementation YXHomeworkListHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    _maskLayer = [CAShapeLayer layer];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:_titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)layoutInterface{
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (_isLast) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth - 10.0f, 45.0f) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
        _maskLayer.frame = self.bounds;
        _maskLayer.path = maskPath.CGPath;
        self.layer.mask = _maskLayer;
    }else{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth - 10.0f, 45.0f) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
        _maskLayer.frame = self.bounds;
        _maskLayer.path = maskPath.CGPath;
        self.layer.mask = _maskLayer;
    }
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLabel.text = _titleString;
    [self layoutInterface];
}
@end
