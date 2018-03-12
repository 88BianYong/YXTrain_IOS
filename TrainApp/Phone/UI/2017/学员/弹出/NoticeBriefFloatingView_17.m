//
//  NoticeBriefFloatingView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeBriefFloatingView_17.h"

@implementation NoticeBriefFloatingView_17

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIImageView *containerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"50%"]];
    containerView.layer.cornerRadius = YXTrainCornerRadii;
    containerView.clipsToBounds = YES;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_centerX).offset(2.0f);
        make.top.equalTo(self.mas_top).offset(kVerticalNavBarHeight + 5.0f + 96.0f);
        make.height.mas_offset(100.0f);
    }];
    UIImageView *noticeBriefImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"简报"]];
    [containerView addSubview:noticeBriefImageView];
    [noticeBriefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX).offset(-1.0f);
        make.size.mas_offset(CGSizeMake(27.0f, 27.0f));
        make.bottom.equalTo(containerView.mas_centerY).offset(-1.0f);
    }];
    
    UILabel *noticeBriefLabel = [[UILabel alloc] init];
    noticeBriefLabel.text = @"通知简报";
    noticeBriefLabel.font = [UIFont systemFontOfSize:13.0f];
    noticeBriefLabel.textColor = [UIColor colorWithHexString:@"334466"];
    noticeBriefLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:noticeBriefLabel];
    [noticeBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX).offset(1.0f);
        make.top.equalTo(containerView.mas_centerY).offset(9.0f);
    }];
    
    UIImageView *pointerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通知简报"]];
    [self addSubview:pointerImageView];
    [pointerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(34.0f, 53.0f));
        make.top.equalTo(containerView.mas_bottom).offset(19.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"点击可查看项目发布的通知和简报"]];
    [self addSubview:descriptionImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朕知道了B"]];
    [self addSubview:imageView];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointerImageView.mas_bottom).offset(19.0f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidthScale(352.0f), kScreenHeightScale(24.0f)));
    }];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionImageView.mas_bottom).offset(72.0f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(148.0f, 46.0f));
    }];
}
@end
