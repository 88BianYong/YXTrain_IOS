//
//  YXScoreTotalScoreCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreTotalScoreHeaderView.h"
#import "YXScoreNoScoreView.h"
#import "YXWaveView.h"
#import "YXExamNoScoreView.h"
#import "YXScoreNoScoreView.h"

@interface YXScoreTotalScoreHeaderView()
@property (nonatomic, strong) UILabel *scoreTitleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *leadScoreTitleLabel;
@property (nonatomic, strong) UILabel *leadScoreLabel;
@property (nonatomic, strong) UILabel *expScoreTitleLabel;
@property (nonatomic, strong) UILabel *expScoreLabel;
@property (nonatomic, strong) YXWaveView *waveView;
@property (nonatomic, strong) YXExamNoScoreView *noScoreView;
@property (nonatomic, strong) YXScoreNoScoreView *noLeadScoreView;
@property (nonatomic, strong) YXScoreNoScoreView *noExpScoreView;
@end

@implementation YXScoreTotalScoreHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
//    self.waveView = [[YXWaveView alloc]init];
//    self.waveView.userInteractionEnabled = NO;
//    self.waveView.hidden = YES;
//    [self addSubview:self.waveView];
//    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    self.scoreTitleLabel = [[UILabel alloc]init];
    self.scoreTitleLabel.font = [UIFont systemFontOfSize:12];
    self.scoreTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.scoreTitleLabel];
    [self.scoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(0);
    }];
    UIView *l = [[UIView alloc]init];
    l.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.scoreTitleLabel.mas_centerY);
        make.right.mas_equalTo(self.scoreTitleLabel.mas_left).mas_offset(-15);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    UIView *r = [[UIView alloc]init];
    r.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self addSubview:r];
    [r mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.scoreTitleLabel.mas_centerY);
        make.left.mas_equalTo(self.scoreTitleLabel.mas_right).mas_offset(15);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:36];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    self.noScoreView = [[YXExamNoScoreView alloc]init];
    UIView *sep = [[UIView alloc]init];
    sep.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scoreTitleLabel.mas_bottom).mas_offset(60);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.height.mas_equalTo(35);
    }];
    self.leadScoreTitleLabel = [[UILabel alloc]init];
    self.leadScoreTitleLabel.font = [UIFont systemFontOfSize:11];
    self.leadScoreTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.leadScoreTitleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.leadScoreTitleLabel];
    [self.leadScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sep.mas_top);
        make.right.mas_equalTo(sep.mas_left).mas_offset(-15);
    }];
    self.leadScoreLabel = [[UILabel alloc]init];
    self.leadScoreLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:18];
    self.leadScoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.leadScoreLabel.textAlignment = NSTextAlignmentRight;
    
    self.noLeadScoreView = [[YXScoreNoScoreView alloc]init];
    
    self.expScoreTitleLabel = [[UILabel alloc]init];
    self.expScoreTitleLabel.font = [UIFont systemFontOfSize:11];
    self.expScoreTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.expScoreTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.expScoreTitleLabel];
    [self.expScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sep.mas_top);
        make.left.mas_equalTo(sep.mas_right).mas_offset(20);
    }];
    self.expScoreLabel = [[UILabel alloc]init];
    self.expScoreLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:18];
    self.expScoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.expScoreLabel.textAlignment = NSTextAlignmentLeft;
    
    self.noExpScoreView = [[YXScoreNoScoreView alloc]init];
}

- (void)setData:(YXExamineRequestItem_body *)data{
    _data = data;
    self.scoreTitleLabel.text = [NSString stringWithFormat:@"总成绩（满分%@）",data.totalfficial];
    self.leadScoreTitleLabel.text = [NSString stringWithFormat:@"引领学习（满分%@）",data.pofficial];
    self.expScoreTitleLabel.text = [NSString stringWithFormat:@"拓展学习（满分%@）",data.punofficial];
    if (data.totalscore.length == 0) {
        [self.scoreLabel removeFromSuperview];
        [self addSubview:self.noScoreView];
        [self.noScoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scoreTitleLabel.mas_bottom).mas_offset(35);
            make.centerX.mas_equalTo(self.scoreTitleLabel.mas_centerX);
            make.width.mas_equalTo(47);
            make.height.mas_equalTo(2);
        }];
    }else{
        [self.noScoreView removeFromSuperview];
        [self addSubview:self.scoreLabel];
        self.scoreLabel.attributedText = [self totalScoreStringWithScore:data.totalscore];
        [self addSubview:self.scoreLabel];
        [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scoreTitleLabel.mas_bottom).mas_offset(6);
            make.centerX.mas_equalTo(self.scoreTitleLabel.mas_centerX);
        }];
    }
    if (data.userGetScore.length == 0) {
        [self.leadScoreLabel removeFromSuperview];
        [self addSubview:self.noLeadScoreView];
        [self.noLeadScoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.leadScoreTitleLabel.mas_bottom).mas_offset(20);
            make.right.mas_equalTo(self.leadScoreTitleLabel.mas_right).mas_offset(-5);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
        }];
    }else{
        [self.noLeadScoreView removeFromSuperview];
        [self addSubview:self.leadScoreLabel];
        self.leadScoreLabel.text = [NSString stringWithFormat:@"%@",data.userGetScore];
        [self addSubview:self.leadScoreLabel];
        [self.leadScoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.leadScoreTitleLabel.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.leadScoreTitleLabel.mas_right).mas_offset(-5);
        }];
    }
    if (data.bounsscore.length == 0) {
        [self.expScoreLabel removeFromSuperview];
        [self addSubview:self.noExpScoreView];
        [self.noExpScoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.expScoreTitleLabel.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.expScoreTitleLabel.mas_left);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
        }];
    }else{
        [self.noExpScoreView removeFromSuperview];
        [self addSubview:self.expScoreLabel];
        self.expScoreLabel.text = [NSString stringWithFormat:@"%@",data.bounsscore];
        [self addSubview:self.expScoreLabel];
        [self.expScoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.expScoreTitleLabel.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(self.expScoreTitleLabel.mas_left);
        }];
    }
}

- (NSMutableAttributedString *)totalScoreStringWithScore:(NSString *)score{
    NSString *completeStr = [NSString stringWithFormat:@"%@分",score];
    NSRange range = [completeStr rangeOfString:@"分"];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontFZLBJW_GB1 size:36] range:range];
    return attr;
}

//- (void)startAnimation{
//    [self.waveView startAnimation];
//}

@end
