//
//  MasterMyLearningScoreCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterMyLearningScoreCell_17.h"
#import "YXMyLearningUserScoreView.h"
@implementation MasterMyLearningScoreCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUIAndLayout];
    }
    return self;
}
#pragma mark - set
- (void)setProcess:(ExamineDetailRequest_17Item_Examine_Process *)process {
    _process = process;
    NSMutableArray<YXMyLearningUserScoreView *> *mutableArray = [[NSMutableArray<YXMyLearningUserScoreView *> alloc] initWithCapacity:4];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YXMyLearningUserScoreView class]]) {
            [obj removeFromSuperview];
        }
        if ([obj isKindOfClass:[UIView class]]) {
            if (obj.tag >= 10086) {
                [obj removeFromSuperview];
            }
        }
    }];
    
    for (int i = 1; i * 4 <= process.toolExamineVoList.count; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
        lineView.tag = 10086 + i;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_top).offset(i * 80.0f);
            make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    
    for (ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *tool in _process.toolExamineVoList) {
        YXMyLearningUserScoreView *view = [[YXMyLearningUserScoreView alloc] init];
        view.nameLabel.text = tool.name;
        view.scoreLabel.attributedText = [self totalScore:[NSString stringWithFormat:@"%0.2f",[tool.totalScore floatValue] + [tool.passTotalScore floatValue]] WithScore:[NSString stringWithFormat:@"%0.2f",[tool.userScore floatValue] + [tool.passFinishScore floatValue]]];
        [self.contentView addSubview:view];
        [mutableArray addObject:view];
    }
    [self setupToolScoreView:mutableArray];
}
- (NSMutableAttributedString *)totalScore:(NSString *)tScore WithScore:(NSString *)score{
    if ([tScore floatValue] == ceilf([tScore floatValue]) && [tScore floatValue] == floorf([tScore floatValue])) {
        tScore = [NSString stringWithFormat:@"%d",[tScore intValue]];
    }
    if ([score floatValue] == ceilf([score floatValue]) && [score floatValue] == floorf([score floatValue])) {
        score = [NSString stringWithFormat:@"%d",[score intValue]];
    }
    
    NSString *completeStr = [NSString stringWithFormat:@"%@ / %@分",score,tScore];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_DemiBold size:13] range:NSMakeRange(0, score.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e96e38"] range:NSMakeRange(0, score.length)];
    return attr;
}


#pragma mark - setupUI
- (void)setupUIAndLayout {
    for (int i = 1; i < 4; i ++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
        lineView.tag = i + 1;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * i - 0.5f/[UIScreen mainScreen].scale);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
    }
}

- (void)setupToolScoreView:(NSArray<YXMyLearningUserScoreView *> *)toolView {
    [toolView enumerateObjectsUsingBlock:^(YXMyLearningUserScoreView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * 80.0f + 40.0f);
            make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * (idx % 4));
            make.width.mas_offset(kScreenWidth/4.0f);
        }];
    }];
}
@end
