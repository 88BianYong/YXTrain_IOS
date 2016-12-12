//
//  BeijingExamTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamTableHeaderView.h"
@interface BeijingExamTableHeaderView ()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *rightLabel;
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
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.text = @"";
    self.leftLabel.font = [UIFont systemFontOfSize:19.0f];
    self.leftLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.leftView addSubview:self.leftLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.leftView addSubview:lineView];
    
    UILabel *statusSignLabel = [[UILabel alloc] init];
    statusSignLabel.text = @"培训状态";
    statusSignLabel.textColor = [UIColor colorWithHexString:@"bec8d8"];
    statusSignLabel.font = [UIFont systemFontOfSize:11.0f];
    statusSignLabel.textAlignment = NSTextAlignmentCenter;
    statusSignLabel.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:statusSignLabel];
    
    [statusSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftLabel.mas_centerX);
        make.bottom.equalTo(self.leftLabel.mas_top).offset(-15.0f);
        make.width.mas_offset(60.0f);
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
    
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.text = @"";
    self.rightLabel.font = [UIFont systemFontOfSize:19.0f];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.rightView addSubview:self.rightLabel];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.rightView addSubview:lineView1];
    
    UILabel *statusSignLabel1 = [[UILabel alloc] init];
    statusSignLabel1.text = @"在线学习状态";
    statusSignLabel1.textColor = [UIColor colorWithHexString:@"bec8d8"];
    statusSignLabel1.font = [UIFont systemFontOfSize:11.0f];
    statusSignLabel1.textAlignment = NSTextAlignmentCenter;
    statusSignLabel1.backgroundColor = [UIColor whiteColor];
    [self.rightView addSubview:statusSignLabel1];
    
    [statusSignLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightLabel.mas_centerX);
        make.bottom.equalTo(self.rightLabel.mas_top).offset(-15.0f);
        make.width.mas_offset(80.0f);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        make.centerY.equalTo(statusSignLabel1.mas_centerY);
        make.centerX.equalTo(statusSignLabel1.mas_centerX);
        make.width.mas_offset(50.0f + 31.0f +31.0f);
    }];
    
    

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
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.leftView);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rightView);
    }];
}
- (void)setItem:(BeijingExamineRequestItem *)item {
    _item = item;
     if (_item.userGetScore.doubleValue < 85.0f) {
        self.rightLabel.text = @"未结束";
     }else if(_item.userGetScore.doubleValue >= 85.0f && _item.userGetScore.doubleValue < 90.0f){
         if (_item.applystatus.integerValue == 0 || _item.applystatus.integerValue == -1) {
             self.rightLabel.text = @"未结束";
         } else if (_item.applystatus.integerValue == 1 || _item.applystatus.integerValue == 3) {
             self.rightLabel.text = @"待审批";
         }else if (_item.applystatus.integerValue == 4) {
             self.rightLabel.text = @"未通过";
         }
     }else if(_item.userGetScore.doubleValue >= 90.0f){
         self.rightLabel.text = @"已通过";
     }

    if (_item.userGetScore.doubleValue < 100.0f) {
        self.leftLabel.text = @"未合格";
    }else {
        self.leftLabel.text = @"已合格";
    }
}
@end
