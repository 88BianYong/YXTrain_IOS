//
//  HomeworkListClaimCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListClaimCell_17.h"
#import "YXExamProgressView.h"
@interface HomeworkListClaimCell_17 ()
@property (nonatomic, strong) UILabel *mainPointLabel;
@property (nonatomic, strong) UILabel *scheduleLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *explainButton;
@end
@implementation HomeworkListClaimCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - set
- (void)setScheme:(HomeworkListRequest_17Item_Scheme *)scheme {
    _scheme = scheme;
    self.mainPointLabel.text = [self mainPointContent:_scheme];
    self.progressView.progress = [_scheme.process.userFinishNum floatValue]/[_scheme.scheme.finishNum floatValue];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",_scheme.scheme.finishNum,_scheme.process.userFinishNum]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0070c9"] range:NSMakeRange(0, _scheme.process.userFinishNum.length)];
    self.scheduleLabel.attributedText = attributedString;
    self.explainButton.hidden = (_scheme.scheme.toolID.integerValue == 218 || _scheme.scheme.toolID.integerValue == 318) ? NO : YES;
}
- (NSString *)mainPointContent:(HomeworkListRequest_17Item_Scheme *)scheme{
    if (scheme.scheme.toolID.integerValue == 219 || scheme.scheme.toolID.integerValue == 319) {
        return [NSString stringWithFormat:@"需要互评%@篇同学作业",scheme.scheme.finishNum];
    }else if (scheme.scheme.toolID.integerValue == 203 || scheme.scheme.toolID.integerValue == 303) {
        return [NSString stringWithFormat:@"需要完成%@篇作业",scheme.scheme.finishNum];
    }else if (scheme.scheme.toolID.integerValue == 218 || scheme.scheme.toolID.integerValue == 318) {
        return [NSString stringWithFormat:@"需要完成%@篇小组作业",scheme.scheme.finishNum];
    }else if (scheme.scheme.toolID.integerValue == 205 || scheme.scheme.toolID.integerValue == 305) {
        return [NSString stringWithFormat:@"需要完成%@篇研修总结",scheme.scheme.finishNum];
    }else {
        return [NSString stringWithFormat:@"需要完成%@篇作业",scheme.scheme.finishNum];
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.mainPointLabel = [[UILabel alloc] init];
    self.mainPointLabel.font = [UIFont systemFontOfSize:14.0f];
    self.mainPointLabel.text = @"你熟练度会计分录卡迪夫;拉的屎啦咖啡";
    self.mainPointLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.mainPointLabel];
    
    self.scheduleLabel = [[UILabel alloc] init];
    self.scheduleLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.scheduleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.scheduleLabel.text = @"1/2";
    [self.contentView addSubview:self.scheduleLabel];
    
    self.progressView = [[YXExamProgressView alloc]init];
    self.progressView.progress = 0.5f;
    [self.contentView addSubview:self.progressView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.lineView.hidden = YES;
    [self.contentView addSubview:self.lineView];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    WEAK_SELF
    [[self.explainButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
       // BLOCK_EXEC(self.myLearningScoreButtonBlock,self.explainButton);
        
    }];
    [self.contentView addSubview:self.explainButton];
}
- (void)setupLayout {
    [self.mainPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(16.0f);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.mainPointLabel.mas_bottom).offset(15.0f);
        make.height.mas_offset(6.0f);
        make.right.equalTo(self.scheduleLabel.mas_left).offset(-20.0f);
    }];
    [self.scheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.progressView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainPointLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.mainPointLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
}
@end
