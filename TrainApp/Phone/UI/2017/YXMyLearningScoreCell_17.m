//
//  YXMyLearningScoreCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyLearningScoreCell_17.h"
@interface YXMyLearningUserScoreView : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@end
@implementation YXMyLearningUserScoreView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.scoreLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10.0f);
            make.centerX.equalTo(self.nameLabel.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
@end
@interface YXMyLearningScoreCell_17 ()
@end

@implementation YXMyLearningScoreCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUIAndLayout];
    }
    return self;
}
#pragma mark - set
- (void)setProcess:(PersonalExamineRequest_17Item_Examine_Process *)process {
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
    
    for (PersonalExamineRequest_17Item_Examine_Process_ToolExamineVoList *tool in _process.toolExamineVoList) {
        YXMyLearningUserScoreView *view = [[YXMyLearningUserScoreView alloc] init];
        view.nameLabel.text = tool.name;
        view.scoreLabel.attributedText = [self totalScore:_process.userScore WithScore:_process.totalScore];
        [self.contentView addSubview:view];
        [mutableArray addObject:view];
    }
    [self setupToolScoreView:mutableArray];
}
- (NSMutableAttributedString *)totalScore:(NSString *)tScore WithScore:(NSString *)score{
    NSString *completeStr = [NSString stringWithFormat:@"%@/%@分",score,tScore];
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
        if ((idx / 4 % 2) == 0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * 80.0f + 40.0f);
                make.left.equalTo(self.contentView.mas_left).offset(kScreenWidth/4.0f * (idx % 4));
                make.width.mas_offset(kScreenWidth/4.0f);
            }];
        }else {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.mas_top).offset(idx/4 * 80.0f + 40.0f);
                make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/4.0f * (idx % 4));
                make.width.mas_offset(kScreenWidth/4.0f);
            }];
        }

    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
