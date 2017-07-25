//
//  CourseTestTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestTableHeaderView_17.h"
@interface CourseTestTableHeaderView_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UILabel *lastAnswerLabel;
@end
@implementation CourseTestTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setup
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor =[UIColor whiteColor];
    [self addSubview:self.containerView];
    self.explainLabel = [[UILabel alloc] init];
    self.explainLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.explainLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.explainLabel.text = @"需要答对6道及以上的题目才能通过课程测验";
    [self.containerView addSubview:self.explainLabel];
    self.lastAnswerLabel = [[UILabel alloc] init];
    self.lastAnswerLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.lastAnswerLabel.font = [UIFont systemFontOfSize:12.0f];
    self.lastAnswerLabel.text = @"上次作答结果:(答对3到打错一堆),2017.05.29 18:09";
    [self.containerView addSubview:self.lastAnswerLabel];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.height.mas_offset(61.0f);
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.containerView.mas_centerY).offset(-4.0f);
    }];
    [self.lastAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.top.equalTo(self.containerView.mas_centerY).offset(4.0f);
    }];
}
@end
