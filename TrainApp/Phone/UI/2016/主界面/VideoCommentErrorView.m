//
//  VideoCommentErrorView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "VideoCommentErrorView.h"
@interface VideoCommentErrorView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *retryButton;
@end
@implementation VideoCommentErrorView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"视频网络断开icon"];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-50);
        make.size.mas_equalTo(CGSizeMake(79.0f, 56.0f));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"网络异常";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5);
    }];
    self.retryButton = [[UIButton alloc]init];
    self.retryButton.backgroundColor = [UIColor colorWithHexString:@"2585d6"];
    [self.retryButton setTitle:@"刷新" forState:UIControlStateNormal];
    [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.retryButton.layer.cornerRadius = YXTrainCornerRadii;
    self.retryButton.clipsToBounds = YES;
    [self addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(115, 33));
    }];
}

- (void)btnAction{
    BLOCK_EXEC(self.retryBlock);
}
@end
