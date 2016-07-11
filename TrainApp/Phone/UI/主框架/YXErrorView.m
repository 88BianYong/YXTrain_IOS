//
//  YXErrorView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXErrorView.h"

@interface YXErrorView()
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIButton *retryButton;
@end

@implementation YXErrorView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.msgLabel = [[UILabel alloc]init];
    self.msgLabel.text = @"网络连接出现了小问题";
    [self addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.retryButton = [[UIButton alloc]init];
    [self.retryButton setTitle:@"重试" forState:UIControlStateNormal];
    [self.retryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.msgLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}

- (void)btnAction{
    BLOCK_EXEC(self.retryBlock);
}

@end
