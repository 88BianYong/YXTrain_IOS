//
//  YXHomeworkInfoFinishHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoFinishHeaderView.h"
@interface YXHomeworkInfoFinishHeaderView()
{
    UILabel *_titleLabel;
}
@end

@implementation YXHomeworkInfoFinishHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    UIView *backgrounView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width - 10.0f, 46.0f)];
    backgrounView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgrounView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgrounView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = backgrounView.bounds;
    maskLayer.path = maskPath.CGPath;
    backgrounView.layer.mask = maskLayer;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(5.0f);
    }];
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}

@end
