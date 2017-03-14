//
//  RemindLeftSlipView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RemindLeftSlipView.h"

@implementation RemindLeftSlipView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIImageView *remindView = [[UIImageView alloc] init];
    remindView.image = [UIImage imageNamed:@"提醒学习"];
    [self addSubview:remindView];
    [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(100.0f, 115.0f));
        make.right.equalTo(self.mas_right).offset(0.0f);
        make.top.equalTo(self.mas_top).offset(64.0f + 44.0f + 150.0f - 15.0f);
    }];
    
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"内容模块A"]];
    [self addSubview:descriptionImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"朕知道了A"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"朕知道了A"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(removeSelfButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(remindView.mas_top).offset(-5.0f);
        make.right.mas_equalTo(self.mas_right).offset(-41.0f);
        make.size.mas_equalTo(CGSizeMake(250.0f, 120.0f));
    }];
    
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(descriptionImageView.mas_top).offset(-5.0f);
        make.left.mas_equalTo(self.mas_left).offset(71.0f);
        make.size.mas_equalTo(CGSizeMake(95.0f, 50.0f));
    }];
}

- (void)removeSelfButtonAction:(UIButton *)sender{
    [self removeFromSuperview];
    BLOCK_EXEC(self.RemindLeftSlipButtonBlock);
}


@end
