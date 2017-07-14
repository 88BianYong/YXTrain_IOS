//
//  YXMyLearningScoreTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyLearningScoreTableHeaderView_17.h"
@interface YXMyLearningScoreContentView : UIView
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@end
@implementation YXMyLearningScoreContentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.font = [UIFont systemFontOfSize:13.0f];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
        [self addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        self.resultLabel = [[UILabel alloc] init];
        self.resultLabel.font = [UIFont systemFontOfSize:13.0f];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        self.resultLabel.textColor = [UIColor colorWithHexString:@"334466"];
        [self addSubview:self.resultLabel];
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scoreLabel.mas_bottom).offset(13.0f);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
@end
@interface YXMyLearningScoreTableHeaderView_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) YXMyLearningScoreContentView *contentView;
@end
@implementation YXMyLearningScoreTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setScoreString:(NSString *)scoreString {
    _scoreString = scoreString;
    NSString *contentString = [NSString stringWithFormat:@"当前成绩: %@",_scoreString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e5581a"] range:NSMakeRange(6, _scoreString.length)];
    self.contentView.scoreLabel.attributedText = attributedString;
}
- (void)setIsPassBool:(BOOL)isPassBool {
    _isPassBool = isPassBool;
    self.contentView.resultLabel.text = _isPassBool ? @"考核结果: 通过" : @"考核结果: 未通过";
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    self.contentView = [[YXMyLearningScoreContentView alloc] init];
    [self.containerView addSubview:self.contentView];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.containerView.mas_width);
    }];    
}

@end
