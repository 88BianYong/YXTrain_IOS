//
//  StudentsLearnTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//
@interface StudentsLearnRateView : UIView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *rateNumberLabel;
@property (nonatomic, strong) UILabel *rateNameLabel;
@end
@implementation StudentsLearnRateView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.rateNumberLabel = [[UILabel alloc] init];
    self.rateNumberLabel.text = @"100%";
    self.rateNumberLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.rateNumberLabel.font = [UIFont systemFontOfSize:14.0f];
    self.rateNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.rateNumberLabel];
    self.rateNameLabel = [[UILabel alloc] init];
    self.rateNameLabel.text = @"参训率";
    self.rateNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.rateNameLabel.font = [UIFont systemFontOfSize:11.0f];
    self.rateNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.rateNameLabel];
    [self.rateNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    [self.rateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateNumberLabel.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}

@end


#import "StudentsLearnTableHeaderView.h"
@interface StudentsLearnTableHeaderView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) StudentsLearnRateView *trainingView;//参训
@property (nonatomic, strong) StudentsLearnRateView *studyView;//学习
@property (nonatomic, strong) StudentsLearnRateView *qualifiedView;//合格
@end
@implementation StudentsLearnTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    UIView *shortLineView = [[UIView alloc] init];
    shortLineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    [self.containerView addSubview:shortLineView];
    self.memberLabel = [[UILabel alloc] init];
    self.memberLabel.text = @"成员";
    self.memberLabel.textAlignment = NSTextAlignmentCenter;
    self.memberLabel.backgroundColor = [UIColor whiteColor];
    self.memberLabel.font = [UIFont systemFontOfSize:12.0f];
    self.memberLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.containerView addSubview:self.memberLabel];
    [shortLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.memberLabel);
        make.height.mas_offset(1.0f);
        make.width.mas_offset(55.0f);
    }];
    
    self.typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"成员人数icon"]];
    [self.containerView addSubview:self.typeImageView];
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.text = @"1219人";
    self.numberLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.numberLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.containerView addSubview:self.numberLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.containerView addSubview:self.lineView];
    
    self.trainingView = [[StudentsLearnRateView alloc] init];
    self.trainingView.rateNameLabel.text = @"参训率";
    [self.containerView addSubview:self.trainingView];
    self.studyView = [[StudentsLearnRateView alloc] init];
    self.studyView.rateNameLabel.text = @"学习率";
    [self.containerView addSubview:self.studyView];
    self.qualifiedView = [[StudentsLearnRateView alloc] init];
    self.qualifiedView.rateNameLabel.text = @"合格率";
    [self.containerView addSubview:self.qualifiedView];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.containerView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingView.mas_right).offset(-1.0/2.0f/[UIScreen mainScreen].scale);
        make.centerY.equalTo(self.trainingView.mas_centerY);
        make.height.mas_offset(31.0f);
        make.width.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.containerView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qualifiedView.mas_left).offset(1.0/2.0f/[UIScreen mainScreen].scale);
        make.centerY.equalTo(self.trainingView.mas_centerY);
        make.height.mas_offset(31.0f);
        make.width.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 0.0f));
    }];
    
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(26.0f);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.width.mas_offset(40.0f);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memberLabel.mas_bottom).offset(6.0f);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberLabel.mas_centerY);
        make.right.equalTo(self.numberLabel.mas_left).offset(-6.0f);
        make.size.mas_offset(CGSizeMake(21.0f, 21.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        make.top.equalTo(self.containerView.mas_top).offset(88.0f);
    }];
    
    [self.trainingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.width.equalTo(self.containerView).multipliedBy(1.0f/3.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
    [self.studyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainingView.mas_right);
        make.width.equalTo(self.containerView).multipliedBy(1.0f/3.0f);
        make.top.equalTo(self.trainingView.mas_top);
        make.bottom.equalTo(self.trainingView.mas_bottom);
    }];
    [self.qualifiedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right);
        make.width.equalTo(self.containerView).multipliedBy(1.0f/3.0f);
        make.top.equalTo(self.trainingView.mas_top);
        make.bottom.equalTo(self.trainingView.mas_bottom);
    }];
}
#pragma - set
- (void)setBody:(MasterLearningInfoListRequestItem_Body *)body {
    _body = body;
    self.numberLabel.text = [NSString stringWithFormat:@"%@人",_body.count];
    self.trainingView.rateNumberLabel.text = [NSString stringWithFormat:@"%@%%",_body.cxl];
    self.studyView.rateNumberLabel.text = [NSString stringWithFormat:@"%@%%",_body.xxl];
    self.qualifiedView.rateNumberLabel.text = [NSString stringWithFormat:@"%@%%",_body.hgl];
}
@end
