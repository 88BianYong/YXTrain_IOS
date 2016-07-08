//
//  YXExamTotalScoreCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamTotalScoreCell.h"
#import "YXWaveView.h"
#import "YXExamNoScoreView.h"

@interface YXExamTotalScoreCell()
@property (nonatomic, strong) UILabel *scoreTitleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *pointTitleLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) YXWaveView *waveView;
@property (nonatomic, strong) YXExamNoScoreView *leftNoScoreView;
@property (nonatomic, strong) YXExamNoScoreView *rightNoScoreView;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation YXExamTotalScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.waveView = [[YXWaveView alloc]init];
    self.waveView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.waveView];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.scoreTitleLabel = [[UILabel alloc]init];
    self.scoreTitleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.scoreTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.scoreTitleLabel.textAlignment = NSTextAlignmentRight;
    self.scoreTitleLabel.text = @"总成绩（满分100）";
    [self.contentView addSubview:self.scoreTitleLabel];
    CGFloat scoreLabelWidth = [self.scoreTitleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.scoreTitleLabel.font}].width;
    [self.scoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-28);
        make.width.mas_equalTo(ceilf(scoreLabelWidth));
    }];
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:23];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.text = @"58.8分";

    self.pointTitleLabel = [[UILabel alloc]init];
    self.pointTitleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.pointTitleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.pointTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.pointTitleLabel.text = @"累计积分";
    [self.contentView addSubview:self.pointTitleLabel];
    CGFloat pointLabelWidth = [self.pointTitleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.pointTitleLabel.font}].width;
    [self.pointTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(46);
        make.width.mas_equalTo(ceilf(pointLabelWidth));
    }];
    self.pointLabel = [[UILabel alloc]init];
    self.pointLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:23];
    self.pointLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.pointLabel.textAlignment = NSTextAlignmentCenter;
    self.pointLabel.text = @"90分";

    self.enterImageView = [[UIImageView alloc]init];
    self.enterImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.leftNoScoreView = [[YXExamNoScoreView alloc]init];
    self.rightNoScoreView = [[YXExamNoScoreView alloc]init];
}

- (void)setTotalScore:(NSString *)totalScore{
    _totalScore = totalScore;
    if (totalScore.length == 0) {
        [self.scoreLabel removeFromSuperview];
        [self.contentView addSubview:self.leftNoScoreView];
        [self.leftNoScoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scoreTitleLabel.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.scoreTitleLabel.mas_centerX);
            make.width.mas_equalTo(47);
            make.height.mas_equalTo(2);
        }];
    }else{
        [self.leftNoScoreView removeFromSuperview];
        [self.contentView addSubview:self.scoreLabel];
        self.scoreLabel.attributedText = [self totalScoreStringWithScore:totalScore];
        [self.contentView addSubview:self.scoreLabel];
        [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scoreTitleLabel.mas_bottom).mas_offset(21);
            make.centerX.mas_equalTo(self.scoreTitleLabel.mas_centerX);
        }];
    }
}

- (void)setTotalPoint:(NSString *)totalPoint{
    _totalPoint = totalPoint;
    if (totalPoint.length == 0) {
        [self.pointLabel removeFromSuperview];
        [self.contentView addSubview:self.rightNoScoreView];
        [self.rightNoScoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pointTitleLabel.mas_bottom).mas_offset(30);
            make.centerX.mas_equalTo(self.pointTitleLabel.mas_centerX);
            make.width.mas_equalTo(47);
            make.height.mas_equalTo(2);
        }];
    }else{
        [self.rightNoScoreView removeFromSuperview];
        [self.contentView addSubview:self.pointLabel];
        self.pointLabel.attributedText = [self totalScoreStringWithScore:totalPoint];
        [self.contentView addSubview:self.pointLabel];
        [self.pointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pointTitleLabel.mas_bottom).mas_offset(21);
            make.centerX.mas_equalTo(self.pointTitleLabel.mas_centerX);
        }];
    }
}

- (NSMutableAttributedString *)totalScoreStringWithScore:(NSString *)score{
    NSString *completeStr = [NSString stringWithFormat:@"%@分",score];
    NSRange range = [completeStr rangeOfString:@"分"];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontFZLBJW_GB1 size:23] range:range];
    return attr;
}

- (void)startAnimation{
    [self.waveView startAnimation];
}

@end
