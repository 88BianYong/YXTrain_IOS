//
//  MasterOverallRatingListTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingListTableHeaderView_17.h"
#import "MasterSchemeView_17.h"

@interface MasterOverallRatingListTableHeaderView_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MasterSchemeView_17 *schemeView;
@end
@implementation MasterOverallRatingListTableHeaderView_17
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setCountUser:(MasterOverallRatingListItem_Body_CountUser *)countUser {
    _countUser = countUser;
    [self.schemeView reloadMasterScheme:[NSString stringWithFormat:@"需要评定%@人",_countUser.allCount] withFinishNum:_countUser.scoreCount withAmount:_countUser.allCount];
    
    
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
        BLOCK_EXEC(self.masterOverallRatingButtonBlock,self.explainButton);
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
        make.bottom.equalTo(self.mas_bottom);
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
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.height.mas_offset(50.0f);
    }];
}
@end
