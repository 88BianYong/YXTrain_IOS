//
//  MasterDetailActiveTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterDetailActiveTableHeaderView_17.h"
@interface MasterDetailActiveTableHeaderView_17 ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *vLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *memeberButton;
@property (nonatomic, strong) UIButton *toolButton;
@end
@implementation MasterDetailActiveTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (CGFloat)relodDetailActiveHeader:(NSString *)contentString withMySelf:(BOOL)isMy {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:contentString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.2f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentString.length)];
    self.descriptionLabel.attributedText = attributedString;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth - 31.0f, ceilf([self.descriptionLabel sizeThatFits:CGSizeMake(kScreenWidth - 30.0f , MAXFLOAT)].height));
    self.scrollView.scrollEnabled = isMy;
    self.toolButton.hidden = !isMy;
    self.toolButton.enabled = NO;
    self.memeberButton.hidden = !isMy;
    self.memeberButton.enabled = YES;
    self.vLineView.hidden = !isMy;
    self.bottomView.hidden = !isMy;
    self.bottomLineView.hidden = !isMy;
    return isMy ? 255.0f : (self.scrollView.contentSize.height + 130.0f);
}
#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.text = @"活动描述";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    self.descriptionLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.descriptionLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:self.bottomView];
    
    self.toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolButton setTitle:@"数据统计" forState:UIControlStateNormal];
    [self.toolButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateDisabled];
    [self.toolButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateHighlighted];
    [self.toolButton setTitleColor:[UIColor colorWithHexString:@"85898f"] forState:UIControlStateNormal];
    self.toolButton.enabled = NO;
    self.toolButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    WEAK_SELF
    [[self.toolButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        STRONG_SELF
        BLOCK_EXEC(self.masterDetailActiveBlock,MasterManageActiveType_Tool);
        x.enabled = NO;
        self.memeberButton.enabled = YES;
    }];
    [self addSubview:self.toolButton];
    
    self.memeberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.memeberButton setTitle:@"成员明细" forState:UIControlStateNormal];
    [self.memeberButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateDisabled];
    [self.memeberButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateHighlighted];
    [self.memeberButton setTitleColor:[UIColor colorWithHexString:@"85898f"] forState:UIControlStateNormal];
    self.memeberButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [[self.memeberButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        STRONG_SELF
        BLOCK_EXEC(self.masterDetailActiveBlock,MasterManageActiveType_Member);
        x.enabled = NO;
        self.toolButton.enabled = YES;
    }];
    [self addSubview:self.memeberButton];
    
    self.vLineView = [[UIView alloc] init];
    self.vLineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:self.vLineView];
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.bottomLineView];
    
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(5.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.lineView.mas_bottom).offset(15.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-65.0f);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.lineView.mas_bottom).offset(15.0f + 123.0f + 15.0f);
        make.height.mas_offset(5.0f);
    }];
    
    
    [self.toolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.bottomView.mas_bottom);
        make.size.mas_offset(CGSizeMake(90.0f, 45.0f));
    }];
    
    [self.memeberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolButton.mas_right);
        make.top.equalTo(self.bottomView.mas_bottom);
        make.size.mas_offset(CGSizeMake(90.0f, 45.0f));
    }];
    
    [self.vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolButton.mas_centerY);
        make.left.equalTo(self.toolButton.mas_right);
        make.size.mas_offset(CGSizeMake(1.0f, 15.0f));
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(1.0f);
    }];
}
@end

