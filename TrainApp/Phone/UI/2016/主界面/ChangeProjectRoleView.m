//
//  ChangeProjectRoleView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChangeProjectRoleView.h"
#import "YXUserProfile.h"
@implementation ChangeProjectRoleView
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
        make.size.mas_offset(CGSizeMake(54.0f, 54.0f));
        make.left.equalTo(self.mas_left).offset(5.0f);
        make.top.equalTo(self.mas_top).offset(20.0f);
    }];

    UIImageView *userHeaderView = [[UIImageView alloc] init];
    userHeaderView.layer.cornerRadius = 16.0f;
    userHeaderView.clipsToBounds = YES;
    [userHeaderView sd_setImageWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].userManger.userModel.profile.head] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    [containerView addSubview:userHeaderView];
    [userHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(32.0f, 32.0f));
        make.center.equalTo(containerView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朕知道了"]];
    [self addSubview:imageView];
    
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"内容模块"]];
    [self addSubview:descriptionImageView];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(70.0f);
        make.left.mas_equalTo(self.mas_left).offset(31.0f);
        make.size.mas_equalTo(CGSizeMake(250.0f, 120.0f));
    }];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionImageView.mas_bottom).offset(16.0f);
        make.left.mas_equalTo(self.mas_left).offset(167.0f);
        make.size.mas_equalTo(CGSizeMake(95.0f, 50.0f));
    }];
}
@end
