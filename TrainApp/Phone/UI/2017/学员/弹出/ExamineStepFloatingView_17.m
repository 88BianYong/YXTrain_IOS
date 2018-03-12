//
//  ExamineStepFloatingView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ExamineStepFloatingView_17.h"

@implementation ExamineStepFloatingView_17
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIImageView *containerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"学习流程"]];
    containerView.layer.cornerRadius = YXTrainCornerRadii;
    containerView.clipsToBounds = YES;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(-2.0f);
        make.width.mas_offset(110.0f);
        make.top.equalTo(self.mas_top).offset(kVerticalNavBarHeight + 110.0f + 96.0f);
        make.height.mas_offset(45.0f);
    }];
    UIView *vLineView = [[UIView alloc] init];
    vLineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    vLineView.layer.cornerRadius = 1.0f;
    [containerView addSubview:vLineView];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(2.0f, 13.0f));
        make.centerY.equalTo(containerView.mas_centerY);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"学习流程";
    label.textColor = [UIColor colorWithHexString:@"#334466"];
    label.font = [UIFont boldSystemFontOfSize:16];
    [containerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vLineView.mas_right).offset(7.0f);
        make.centerY.equalTo(containerView.mas_centerY);
    }];
    
    
    UIImageView *pointerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"学习详情"]];
    [self addSubview:pointerImageView];
    [pointerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(34.0f, 53.0f));
        make.top.equalTo(containerView.mas_bottom).offset(19.0f);
        make.left.equalTo(containerView.mas_right).offset(17.0f);
    }];
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"按流程逐步完成各个环节和任务-即可完成培训学习"]];
    [self addSubview:descriptionImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朕知道了B"]];
    [self addSubview:imageView];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointerImageView.mas_bottom).offset(19.0f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidthScale(329.0f), kScreenHeightScale(65.0f)));
    }];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionImageView.mas_bottom).offset(37.0f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(148.0f, 46.0f));
    }];
}
@end
