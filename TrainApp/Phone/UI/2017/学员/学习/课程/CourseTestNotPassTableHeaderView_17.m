//
//  CourseTestNotPassTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//
#import "CourseTestNotPassTableHeaderView_17.h"
@interface CourseTestResultView : UIView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *rateNumberLabel;
@property (nonatomic, strong) UILabel *rateNameLabel;
@end
@implementation CourseTestResultView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        [self setupUI];
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
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
@interface CourseTestNotPassTableHeaderView_17 ()
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel*recordingLabel;
@property (nonatomic, strong) CourseTestResultView *correcView;//答对
@property (nonatomic, strong) CourseTestResultView *wrongView;//答错
@property (nonatomic, strong) CourseTestResultView *passRateView;//正确率
@end

@implementation CourseTestNotPassTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setQuizesItem:(CourseSubmitUserQuizesRequest_17Item *)quizesItem {
    _quizesItem = quizesItem;
    if(_quizesItem.correctNum.floatValue/_quizesItem.totalNum.floatValue >= 0.6f) {
       self.resultLabel.text = @"已通过";
    }else {
        self.resultLabel.text = @"未通过";
    }
    self.correcView.rateNumberLabel.text = _quizesItem.correctNum;
    self.wrongView.rateNumberLabel.text = [NSString stringWithFormat:@"%ld",_quizesItem.totalNum.integerValue - _quizesItem.correctNum.integerValue];
    self.passRateView.rateNumberLabel.text = [NSString stringWithFormat:@"%0.0f%%",_quizesItem.correctNum.floatValue/_quizesItem.totalNum.floatValue * 100];
}
#pragma mark - setupUI
- (void)setupUI {
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.text = @"成员";
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.backgroundColor = [UIColor whiteColor];
    self.resultLabel.font = [UIFont systemFontOfSize:24.0f];
    self.resultLabel.textColor = [UIColor colorWithHexString:@"eba180"];
    [self addSubview:self.resultLabel];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    
    self.correcView = [[CourseTestResultView alloc] init];
    self.correcView.rateNameLabel.text = @"答对";
    [self addSubview:self.correcView];
    self.wrongView = [[CourseTestResultView alloc] init];
    self.wrongView.rateNameLabel.text = @"答错";
    [self addSubview:self.wrongView];
    self.passRateView = [[CourseTestResultView alloc] init];
    self.passRateView.rateNameLabel.text = @"正确率";
    [self addSubview:self.passRateView];
    
    self.recordingLabel = [[UILabel alloc] init];
    self.recordingLabel.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.recordingLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.recordingLabel.font = [UIFont systemFontOfSize:13.0f];
    self.recordingLabel.text = @"    答题记录";
    [self addSubview:self.recordingLabel];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.correcView.mas_right).offset(-1.0/2.0f/[UIScreen mainScreen].scale);
        make.centerY.equalTo(self.correcView.mas_centerY);
        make.height.mas_offset(31.0f);
        make.width.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passRateView.mas_left).offset(1.0/2.0f/[UIScreen mainScreen].scale);
        make.centerY.equalTo(self.passRateView.mas_centerY);
        make.height.mas_offset(31.0f);
        make.width.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];

}
- (void)setupLayout {
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(88.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        make.top.equalTo(self.resultLabel.mas_bottom);
    }];
    [self.correcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/3.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_offset(52.0f);
    }];
    [self.wrongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.correcView.mas_right);
        make.width.equalTo(self).multipliedBy(1.0f/3.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_offset(52.0f);
    }];
    [self.passRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/3.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_offset(52.0f);
    }];
    
    [self.recordingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(30.0f);
    }];
}
@end
