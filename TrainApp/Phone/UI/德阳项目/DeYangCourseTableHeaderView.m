//
//  DeYangCourseTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeYangCourseTableHeaderView.h"
@interface DeYangCourseTableHeaderView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation DeYangCourseTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
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
    
    self.typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"随堂练icon"]];
    [self.containerView addSubview:self.typeImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"随堂练";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.containerView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
    self.contentLabel.text = @"当前阶段答对15个,共作答1008个";
    [self.containerView addSubview:self.contentLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d2d8df"];
    [self.containerView addSubview:self.lineView];
}

- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(5.0f);
    }];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeImageView.mas_right).offset(2.0f);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.centerY.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}
- (void)setQuiz:(YXCourseListRequestItem_body_module_course_quiz<Optional> *)quiz {
    _quiz = quiz;
    self.contentLabel.text = [NSString stringWithFormat:@"当前阶段答对%@个,共作答%@个",_quiz.finish,_quiz.total];
}
@end
