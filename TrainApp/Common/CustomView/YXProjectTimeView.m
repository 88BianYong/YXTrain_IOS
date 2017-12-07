//
//  YXProjecTimeView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXProjectTimeView.h"
@interface YXProjectTimeView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *vLineView;
@property (nonatomic, strong) UIView *hLineView;
@property (nonatomic, strong) UILabel *timeLabel;
@end
@implementation YXProjectTimeView
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
    
    self.vLineView = [[UIView alloc] init];
    self.vLineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    self.vLineView.layer.cornerRadius = 1.0f;
    [self.containerView addSubview:self.vLineView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"项目时间";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.containerView addSubview:self.titleLabel];
    
    self.hLineView = [[UIView alloc] init];
    self.hLineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.containerView addSubview:self.hLineView];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[LSTSharedInstance sharedInstance].trainManager.currentProject.startDate,[LSTSharedInstance sharedInstance].trainManager.currentProject.endDate];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-5.0f);
    }];
    
    [self.vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(2.0f, 13.0f));
        make.top.equalTo(self.containerView.mas_top).offset(16.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vLineView.mas_right).offset(7.0f);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_offset(45.0f);
    }];
    
    [self.hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.self.hLineView.mas_bottom);
        make.height.mas_offset(45.0f);
    }];
}

@end
