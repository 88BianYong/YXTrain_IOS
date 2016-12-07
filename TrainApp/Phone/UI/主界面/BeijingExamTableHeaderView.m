//
//  BeijingExamTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamTableHeaderView.h"
@interface BeijingExamTableHeaderView ()
@property (nonatomic, strong) UILabel *statusContentLabel;
@property (nonatomic, strong) UIImageView *graduationImageView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;


@end

@implementation BeijingExamTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.leftView = [[UIView alloc] init];
    self.leftView.backgroundColor = [UIColor whiteColor];
    self.leftView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:self.leftView];
    
    self.statusContentLabel = [[UILabel alloc] init];
    self.statusContentLabel.text = @"未提交";
    self.statusContentLabel.font = [UIFont systemFontOfSize:19.0f];
    self.statusContentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.leftView addSubview:self.statusContentLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.leftView addSubview:lineView];
    
    UILabel *statusSignLabel = [[UILabel alloc] init];
    statusSignLabel.text = @"学习状态";
    statusSignLabel.textColor = [UIColor colorWithHexString:@"bec8d8"];
    statusSignLabel.font = [UIFont systemFontOfSize:12.0f];
    statusSignLabel.textAlignment = NSTextAlignmentCenter;
    statusSignLabel.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:statusSignLabel];
    
    [statusSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusContentLabel.mas_centerX);
        make.bottom.equalTo(self.statusContentLabel.mas_top).offset(-15.0f);
        make.width.mas_offset(50.0f);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        make.centerY.equalTo(statusSignLabel.mas_centerY);
        make.centerX.equalTo(statusSignLabel.mas_centerX);
        make.width.mas_offset(50.0f + 31.0f +31.0f);
    }];
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor whiteColor];
    self.rightView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:self.rightView];
    
    self.graduationImageView = [[UIImageView alloc] init];
    [self.rightView addSubview:self.graduationImageView];

}
- (void)setupLayout {
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10.0f);
        make.width.equalTo(self.rightView.mas_width);
        make.bottom.mas_offset(-10.0f);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0f);
        make.left.equalTo(self.leftView.mas_right).offset(9.0f).priorityHigh();
        make.right.bottom.mas_equalTo(-10.0f);
    }];
    
    [self.statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.leftView);
    }];
    
    [self.graduationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rightView);
        make.size.mas_offset(CGSizeMake(90.0f, 90.0f));
    }];
}
- (void)setItem:(BeijingExamineRequestItem *)item {
    _item = item;
    if (_item.applystatus.integerValue == 0) {
        self.graduationImageView.image = [UIImage imageNamed:@"未申请"];
    }else if (_item.applystatus.integerValue == 1 || _item.applystatus.integerValue == 3) {
        self.graduationImageView.image = [UIImage imageNamed:@"已申请"];
    }else if (_item.applystatus.integerValue == -1){
        self.graduationImageView.image = [UIImage imageNamed:@"已退回"];
    }
    
    if (_item.userGetScore.doubleValue < 85.0f) {
        self.statusContentLabel.text = @"未提交";
    }else if (_item.userGetScore.doubleValue >= 85.0f && _item.userGetScore.doubleValue < 100.0f){
        self.statusContentLabel.text = @"已提交";
    }else {
        self.statusContentLabel.text = @"已结业";
        self.graduationImageView.image = [UIImage imageNamed:@"已结业"];
    }
}

// 0 表示：未申请 ；1，已申请，-1是已退回  3、再次申请结业
@end
