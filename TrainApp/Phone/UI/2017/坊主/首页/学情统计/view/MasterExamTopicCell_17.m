//
//  MasterExamTopicCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterExamTopicCell_17.h"
#import "MasterCircleDisplayView_17.h"
#define kCircleWidth 80.0f
@interface MasterExamTopicCell_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) MasterCircleDisplayView_17 *trainingView;
@property (nonatomic, strong) MasterCircleDisplayView_17 *learningView;
@property (nonatomic, strong) MasterCircleDisplayView_17 *qualifiedView;
@property (nonatomic, strong) MasterCircleDisplayView_17 *bestView;

@property (nonatomic, assign) CGFloat spacingFloat;
@end
@implementation MasterExamTopicCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.spacingFloat = (kScreenWidth - (kCircleWidth * 3.5f))/4.0f;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma makr - set
- (void)setDetail:(MasterLearningInfoRequestItem_Body_Count *)detail {
    _detail = detail;
    self.trainingView.progress = [_detail.cxl floatValue]/100.0f;
    self.learningView.progress = [_detail.xxl floatValue]/100.0f;
    self.qualifiedView.progress = [_detail.hgl floatValue]/100.0f;
    self.bestView.progress = [_detail.bestl floatValue]/100.0f;
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.text = @"考核说明";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    WEAK_SELF
    [[self.explainButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.masterExamTopicButtonBlock,self.explainButton);
        
    }];
    [self.contentView addSubview:self.explainButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth + kCircleWidth/2.0f + self.spacingFloat, 100.0f);
    [self.contentView addSubview:self.scrollView];
    
    self.trainingView = [[MasterCircleDisplayView_17 alloc] init];
    self.trainingView.titleString = @"参训统计";
    [self.scrollView addSubview:self.trainingView];
    self.learningView = [[MasterCircleDisplayView_17 alloc] init];
    self.learningView.titleString = @"学习统计";
    [self.scrollView addSubview:self.learningView];
    self.qualifiedView = [[MasterCircleDisplayView_17 alloc] init];
    self.qualifiedView.titleString = @"合格统计";
    [self.scrollView addSubview:self.qualifiedView];
    self.bestView = [[MasterCircleDisplayView_17 alloc] init];
    self.bestView.titleString = @"≥90分比例";
    [self.scrollView addSubview:self.bestView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_offset(45.0f);
    }];
    
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.trainingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 97.0f));
        make.left.equalTo(self.scrollView.mas_left).offset(self.spacingFloat);
        make.top.equalTo(self.scrollView.mas_top).offset(25.0f);
    }];
    
    [self.learningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 97.0f));
        make.left.equalTo(self.trainingView.mas_right).offset(self.spacingFloat);
        make.top.equalTo(self.scrollView.mas_top).offset(25.0f);
    }];
    [self.qualifiedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 97.0f));
        make.left.equalTo(self.learningView.mas_right).offset(self.spacingFloat);
        make.top.equalTo(self.scrollView.mas_top).offset(25.0f);
    }];
    [self.bestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 97.0f));
        make.left.equalTo(self.qualifiedView.mas_right).offset(self.spacingFloat);
        make.top.equalTo(self.scrollView.mas_top).offset(25.0f);
    }];
}

@end
