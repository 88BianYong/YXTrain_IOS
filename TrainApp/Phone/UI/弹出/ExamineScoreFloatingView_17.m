//
//  ExamineScoreFloatingView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ExamineScoreFloatingView_17.h"
@interface ExamineScoreFloatingView_17 ()
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreNameLabel;
@end

@implementation ExamineScoreFloatingView_17
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}
- (void)setScoreString:(NSString *)scoreString {
    _scoreString = scoreString;
    self.scoreLabel.text = _scoreString;
}

- (void)setupUIAndLayoutInterface{
    UIImageView *containerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"50%"]];
    containerView.layer.cornerRadius = YXTrainCornerRadii;
    containerView.clipsToBounds = YES;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(-2.0f);
        make.right.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(69.0f);
        make.height.mas_offset(100.0f);
    }];
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:31.0f];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.text = @"70";
    [containerView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX).offset(1.0f);
        make.bottom.equalTo(containerView.mas_centerY).offset(2.0f);
    }];
    
    self.scoreNameLabel = [[UILabel alloc] init];
    self.scoreNameLabel.text = @"我的成绩";
    self.scoreNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.scoreNameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.scoreNameLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:self.scoreNameLabel];
    [self.scoreNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX).offset(1.0f);
        make.top.equalTo(containerView.mas_centerY).offset(5.0f);
    }];
    
    
    UIImageView *pointerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"学习详情"]];
    [self addSubview:pointerImageView];
    [pointerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(34.0f, 53.0f));
        make.top.equalTo(containerView.mas_bottom).offset(19.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    UIImageView *descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"点击可查看学习成绩"]];
    [self addSubview:descriptionImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朕知道了B"]];
    [self addSubview:imageView];
    
    [descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pointerImageView.mas_bottom).offset(19.0f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(211.0f, 24.0f));
    }];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionImageView.mas_bottom).offset(72.0f);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(148.0f, 46.0f));
    }];
}
@end
