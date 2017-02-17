//
//  UserStatusView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserStatusView.h"
@interface UserStatusView ()
@property (nonatomic, strong) UIButton *masterButton;
@property (nonatomic, strong) UIButton *studentButton;
@end
@implementation UserStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setup
- (void)setupUI {
    self.masterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.masterButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.masterButton setTitle:@"我是坊主" forState:UIControlStateNormal];
    self.masterButton.layer.cornerRadius = YXTrainCornerRadii;
    self.masterButton.layer.borderWidth = 1.0f;
    WEAK_SELF
    [[self.masterButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        if (!self.isMasterBool) {
            self.isMasterBool = YES;
            [YXTrainManager sharedInstance].currentProject.role = @"99";
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainUserIdentityChange object:nil];
        }
    }];
    [self addSubview:self.masterButton];
    self.studentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.studentButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.studentButton setTitle:@"我是学员" forState:UIControlStateNormal];
    self.studentButton.layer.cornerRadius = YXTrainCornerRadii;
    self.studentButton.layer.borderWidth = 1.0f;
    [[self.studentButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        if (self.isMasterBool) {
            self.isMasterBool = NO;
            [YXTrainManager sharedInstance].currentProject.role = @"9";
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainUserIdentityChange object:nil];
        }
    }];
    [self addSubview:self.studentButton];
}
- (void)setupLayout {
    [self.masterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(76.0f);
    }];
    [self.studentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.masterButton.mas_right).offset(17.0f);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(76.0f);
    }];
}
#pragma mark - set
- (void)setIsMasterBool:(BOOL)isMasterBool {
    _isMasterBool = isMasterBool;
    if (_isMasterBool) {
        self.masterButton.backgroundColor = [UIColor colorWithHexString:@"2981cf"];
        [self.masterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.masterButton.layer.borderColor = [UIColor colorWithHexString:@"2981cf"].CGColor;
        self.studentButton.backgroundColor = [UIColor whiteColor];
        [self.studentButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
        self.studentButton.layer.borderColor = [UIColor colorWithHexString:@"b9c0c7"].CGColor;
    }else {
        self.studentButton.backgroundColor = [UIColor colorWithHexString:@"2981cf"];
        [self.studentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.studentButton.layer.borderColor = [UIColor colorWithHexString:@"2981cf"].CGColor;
        self.masterButton.backgroundColor = [UIColor whiteColor];
        [self.masterButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
        self.masterButton.layer.borderColor = [UIColor colorWithHexString:@"b9c0c7"].CGColor;
    }
}
@end
