//
//  YXWorkshopDetailHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDetailHeaderView.h"
@interface YXWorkshopDetailHeaderView()
{
    UIImageView *_headerImageView;
    UILabel *_nameLable;
    UIImageView *_iconImageView;
    UILabel *_masterLabel;
    
}
@end
@implementation YXWorkshopDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self layoutInterface];
        
    }
    return self;
}

- (void)setupUI{
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.image = [UIImage imageNamed:@"工作坊详情大icon"];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headerImageView];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.font = [UIFont boldSystemFontOfSize:15.0f];
    _nameLable.textColor = [UIColor colorWithHexString:@"334466"];
    _nameLable.text = @"暂无";
    [self addSubview:_nameLable];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"房主图标"];
    [self addSubview:_iconImageView];
    
    _masterLabel = [[UILabel alloc] init];
    _masterLabel.font = [UIFont systemFontOfSize:12.0f];
    _masterLabel.text = [NSString stringWithFormat:@"%@  暂无",[YXTrainManager sharedInstance].trainHelper.workshopDetailName];
    _masterLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self addSubview:_masterLabel];
}

- (void)layoutInterface{
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10.0f);
        make.height.with.mas_equalTo(70.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(91.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.width.lessThanOrEqualTo(self.mas_width).offset(-30.0f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_masterLabel.mas_top);
        make.width.height.offset(14.0f);
        make.right.equalTo(self->_masterLabel.mas_left).offset(-2.0f);
    }];
    
    [_masterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_nameLable.mas_bottom).offset(12.0f);
        make.centerX.equalTo(self.mas_centerX).offset(8.0f);
        make.width.lessThanOrEqualTo(self.mas_width).offset(-50.0f);
    }];
}
- (void)reloadWithName:(NSString *)nameString
                master:(NSString *)masterString{
    _nameLable.text = nameString;
    _masterLabel.text = [NSString stringWithFormat:@"%@  %@",[YXTrainManager sharedInstance].trainHelper.workshopDetailName,masterString];
}
@end
