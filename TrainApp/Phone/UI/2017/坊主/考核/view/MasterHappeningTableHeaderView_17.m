//
//  MasterHappeningTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//
@interface MasterTableHeaderLabel_17 : UIView
@end
@implementation MasterTableHeaderLabel_17
- (instancetype)initWithExplain:(NSString *)string {
    if (self = [super init]) {
        [self setupUIWithExplain:string];
    }
    return self;
}

- (void)setupUIWithExplain:(NSString *)string {
    UILabel *explainLabel = [[UILabel alloc] init];
    explainLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    explainLabel.font = [UIFont systemFontOfSize:11.0f];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.text = string;
    [self addSubview:explainLabel];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    UIView *pointView = [[UIView alloc] init];
    pointView.layer.cornerRadius = 1.5f;
    pointView.backgroundColor = [UIColor colorWithHexString:@"8ec5f0"];
    [self addSubview:pointView];
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(3.0f, 3.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(explainLabel.mas_left).offset(-6.0f);
    }];
}

@end

#import "MasterHappeningTableHeaderView_17.h"

#import "YXWaveView.h"
@interface MasterHappeningTableHeaderView_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *totalNameLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIImageView *explainImageView;
@property (nonatomic, strong) MasterTableHeaderLabel_17 *topExplainLabel;
@property (nonatomic, strong) MasterTableHeaderLabel_17 *bottomExplainLabel;
@property (nonatomic ,strong) NSTextAttachment *textAttachment;
@property (nonatomic, strong) YXWaveView *waveView;
@end
@implementation MasterHappeningTableHeaderView_17

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        self.textAttachment = [[NSTextAttachment alloc] init];
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
    self.waveView = [[YXWaveView alloc]init];
    self.waveView.userInteractionEnabled = NO;
    self.waveView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.waveView];
    
    self.totalNameLabel = [[UILabel alloc] init];
    self.totalNameLabel.text = @"我的成绩:";
    self.totalNameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.totalNameLabel.textColor = [UIColor colorWithHexString:@"33446"];
    self.totalNameLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.totalNameLabel];
    
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.text = @"89.6分";
    self.totalLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:23];
    self.totalLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    [self.containerView addSubview:self.totalLabel];
    
    self.explainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的成绩解释说明标签"]];
    [self.containerView addSubview:self.explainImageView];
    
    self.topExplainLabel = [[MasterTableHeaderLabel_17 alloc] initWithExplain:@"成绩考核为百分制,60分为合格"];
    [self.containerView addSubview:self.topExplainLabel];
    
    self.bottomExplainLabel = [[MasterTableHeaderLabel_17 alloc] initWithExplain:@"成绩数据更新约有延迟5小时,如有异常请稍后查看"];
    [self.containerView addSubview:self.bottomExplainLabel];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f));
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    
    [self.totalNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(30.0f);
        make.right.equalTo(self.containerView.mas_centerX).offset(-10.0f);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalNameLabel.mas_centerY);
        make.left.equalTo(self.containerView.mas_centerX).offset(10.0f);
    }];
    
    [self.explainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(22.0f, 22.0f));
        make.top.equalTo(self.containerView.mas_top).offset(55.0f);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    
    [self.topExplainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainImageView.mas_bottom).offset(7.0f);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    [self.bottomExplainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topExplainLabel.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
}
#pragma mark - set
- (void)setTotalString:(NSString *)totalString {
    self.textAttachment.image = [UIImage imageNamed:@"考核页面的的分"];
    self.textAttachment.bounds = CGRectMake(0, -2.5f, 21.0f, 21.0f);
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:self.textAttachment];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:totalString?:@""];
    [attr appendAttributedString:attrStringWithImage];
    self.totalLabel.attributedText = attr;
}

@end
