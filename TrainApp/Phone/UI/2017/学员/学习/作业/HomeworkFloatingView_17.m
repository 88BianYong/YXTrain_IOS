//
//  HomeworkFloatingView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkFloatingView_17.h"

@implementation HomeworkFloatingView_17

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app仅支持查看作业信息，请用-电脑登录研修网完成作业～"]];
    [self addSubview:descriptionImageView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朕知道了B"]];
    [self addSubview:imageView];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kScreenWidthScale(317.f));
        make.height.mas_offset(kScreenHeightScale(64.0f));
        make.top.equalTo(self.mas_top).offset(kScreenHeightScale(244.0f));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(148.0f, 46.0f));
        make.top.equalTo(descriptionImageView.mas_bottom).offset(kScreenHeightScale(66.0f));
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)removeSelfButtonAction:(UIButton *)sender{
    [self removeFromSuperview];
}

@end
