//
//  YXLearningStageHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningStageHeaderView_17.h"
@interface YXLearningIntroductionView : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@end
@implementation YXLearningIntroductionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.nameLabel.text = @"概述";
        self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
        }];
        
        self.startTimeLabel = [[UILabel alloc] init];
        self.startTimeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.startTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        self.startTimeLabel.text = @"开始时间: 2017.05.05";
        [self addSubview:self.startTimeLabel];
        [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10.0f);
        }];
        
        self.statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小锁（未打开）"]];
        [self addSubview:self.statusImageView];
        [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(12.0f, 15.0f));
            make.left.equalTo(self.nameLabel.mas_right).offset(10.0f);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
        }];
    }
    return self;
}
@end


@interface YXLearningStageHeaderView_17 ()
@property (nonatomic, strong) YXLearningIntroductionView *introductionView;
@property (nonatomic, strong) UIImageView *finishImageView;
@property (nonatomic, strong) UIImageView *enterImageView;
@property (nonatomic, strong) UIButton *bgButton;
@end
@implementation YXLearningStageHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WEAK_SELF
    [[self.bgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (!self.stage.status.boolValue) {
            return;
        }
        BLOCK_EXEC(self.learningStageHeaderViewBlock);
    }];
    [[self.bgButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        STRONG_SELF
        if (!self.stage.status.boolValue) {
            return;
        }
        if (self.stage.isMockFold.boolValue) {
            self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头-点击态"];
        }else{
            self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开收起箭头"];
        }
    }];
    [self.contentView addSubview:self.bgButton];
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.introductionView = [[YXLearningIntroductionView alloc] init];
    [self.contentView addSubview:self.introductionView];    
    self.enterImageView = [[UIImageView alloc]init];
    self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
    [self.contentView addSubview:self.enterImageView];
    self.finishImageView = [[UIImageView alloc]init];
    self.finishImageView.image = [UIImage imageNamed:@"完成学习任务标签"];
    [self.contentView addSubview:self.finishImageView];
}
- (void)setupLayout {
    [self.introductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.finishImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(46, 38));
        make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10);
    }];
}
#pragma mark - set 
- (void)setStage:(ExamineDetailRequest_17Item_Stages *)stage {
    _stage = stage;
    self.finishImageView.hidden = !_stage.isFinish.boolValue;
    if (_stage.isMockFold.boolValue) {
        self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
    }else{
        self.enterImageView.image = [UIImage imageNamed:@"第二阶段收起箭头"];
    }
    self.introductionView.statusImageView.hidden = _stage.status.boolValue;
    self.introductionView.nameLabel.text = _stage.name;
    self.introductionView.startTimeLabel.text = [NSString stringWithFormat:@"开始时间: %@",_stage.startTime];
}
@end
