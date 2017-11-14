//
//  QRCodeFloatingView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QRCodeFloatingView.h"

@implementation QRCodeFloatingView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.cornerRadius = YXTrainCornerRadii;
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(45.0f, 45.0f));
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(20.0f);
    }];
    
    UIImageView *userHeaderView = [[UIImageView alloc] init];
    userHeaderView.layer.cornerRadius = 16.0f;
    userHeaderView.clipsToBounds = YES;
    userHeaderView.image = [UIImage imageNamed:@"扫二维码"];
    [containerView addSubview:userHeaderView];
    [userHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(44.0f, 44.0f));
        make.center.equalTo(containerView);
    }];
    
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"内容模块B"]];
    [self addSubview:descriptionImageView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朕知道了"]];
    [self addSubview:imageView];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_bottom);
        make.right.mas_equalTo(self.mas_right).offset(-50.0f);
        make.size.mas_equalTo(CGSizeMake(252.0f, 127.0f));
    }];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionImageView.mas_bottom).offset(5.0f);
        make.right.equalTo(self.mas_right).offset(-83.0f);
        make.size.mas_equalTo(CGSizeMake(95.0f, 50.0f));
    }];
}
@end
