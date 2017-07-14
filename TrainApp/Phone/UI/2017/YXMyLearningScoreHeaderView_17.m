//
//  YXMyLearningScoreHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyLearningScoreHeaderView_17.h"
@interface YXMyLearningScoreHeaderView_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UILabel *scoreLable;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation YXMyLearningScoreHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setProcess:(PersonalExamineRequest_17Item_Examine_Process *)process {
    _process = process;
    self.titleLabel.text = process.name;
    self.scoreLable.attributedText = [self totalScore:process.totalScore WithScore:_process.userScore];
}
#pragma mark - setupUI
- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    WEAK_SELF
    [[self.explainButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.myLearningScoreButtonBlock,self.explainButton);

    }];
    [self.contentView addSubview:self.explainButton];
    
    self.scoreLable = [[UILabel alloc] init];
    self.scoreLable.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.scoreLable.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.scoreLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.scoreLable];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    [self.scoreLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}
- (NSMutableAttributedString *)totalScore:(NSString *)tScore WithScore:(NSString *)score{
    NSString *completeStr = [NSString stringWithFormat:@"%@/%@分",score,tScore];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_DemiBold size:13] range:NSMakeRange(0, score.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e96e38"] range:NSMakeRange(0, score.length)];
    return attr;
}
@end
