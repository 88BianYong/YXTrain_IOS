//
//  MasterBriefHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterBriefHeaderView_17.h"
#import "MasterSchemeView_17.h"
@interface MasterBriefHeaderView_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MasterSchemeView_17 *schemeView;
@end
@implementation MasterBriefHeaderView_17
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
- (void)setScheme:(MasterNoticeBriefScheme *)scheme {
    _scheme = scheme;
    [self.schemeView reloadMasterScheme:[NSString stringWithFormat:@"需要发布%@篇简报(手机端暂不支持，请到PC端完成)",_scheme.amount] withFinishNum:_scheme.userfinishnum withAmount:_scheme.amount];
    if ([_scheme.descripe stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        self.explainButton.hidden = NO;
    }else {
        self.explainButton.hidden = YES;
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.text = @"考核说明";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.containerView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    WEAK_SELF
    [[self.explainButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.masterBriefButtonBlock,self.explainButton);
    }];
    [self.containerView addSubview:self.explainButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.containerView addSubview:self.lineView];
    
    self.schemeView = [[MasterSchemeView_17 alloc] init];
    [self.containerView addSubview:self.schemeView];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-5.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.top.equalTo(self.containerView.mas_top).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    [self.schemeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.centerY.equalTo(self.containerView.mas_centerY).offset(11.5f);
        make.height.mas_offset(50.0f);
    }];
}
@end
