//
//  YXLearningStageHeaderView_DeYang17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXLearningStageHeaderView_DeYang17.h"
@interface YXLearningIntroductionDeYangView :UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIButton *explainButton;
@end
@implementation YXLearningIntroductionDeYangView

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
        self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态A"]
                            forState:UIControlStateNormal];
        [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态A"]
                            forState:UIControlStateHighlighted];
        [self addSubview:self.explainButton];
        [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(7.0f - 10.0f);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.size.mas_offset(CGSizeMake(19.0f + 20.0f, 19.0f + 20.0f));
        }];
        
        self.statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小锁（未打开）"]];
        [self addSubview:self.statusImageView];
        [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(12.0f, 15.0f));
            make.left.equalTo(self.explainButton.mas_right).offset(5.0f);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
        }];
    }
    return self;
}
@end


@interface YXLearningStageHeaderView_DeYang17 ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) YXLearningIntroductionDeYangView *introductionView;
@property (nonatomic, strong) UIImageView *finishImageView;
@property (nonatomic, strong) UIImageView *enterImageView;
@property (nonatomic, strong) UILabel *scoreLabel;

@end
@implementation YXLearningStageHeaderView_DeYang17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    WEAK_SELF
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
//    recognizer.minimumPressDuration = 0.01f;
    recognizer.delegate = self;
    [[recognizer rac_gestureSignal] subscribeNext:^(UILongPressGestureRecognizer*sender) {
        STRONG_SELF
        if (sender.state == UIGestureRecognizerStateBegan) {
            if (self.proces.stageID.integerValue == 0) {
                return;
            }
            if (self.proces.isMockFold.boolValue) {
                self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开收起箭头"];
            }else{
                self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头-点击态"];
            }
        }else if (sender.state == UIGestureRecognizerStateEnded){
            if (self.proces.isMockFold.boolValue) {
                self.enterImageView.image = [UIImage imageNamed:@"第二阶段收起箭头"];
            }else{
                self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
            }
            BLOCK_EXEC(self.learningStageHeaderViewBlock,NO);
        }
    }];
    [self.contentView addGestureRecognizer:recognizer];
    self.enterImageView = [[UIImageView alloc]init];
    self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
    [self.contentView addSubview:self.enterImageView];
    self.finishImageView = [[UIImageView alloc]init];
    self.finishImageView.image = [UIImage imageNamed:@"完成学习任务标签"];
    [self.contentView addSubview:self.finishImageView];
    self.introductionView = [[YXLearningIntroductionDeYangView alloc] init];
    [self.contentView addSubview:self.introductionView];
    [[self.introductionView.explainButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.learningStageExplainBlock,self.introductionView.explainButton);
    }];
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont systemFontOfSize:11.0f];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    [self.contentView addSubview:self.scoreLabel];
    
}
- (void)setupLayout {
    [self.introductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.5f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.5f);

    }];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.finishImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}
#pragma mark - set
- (void)setProces:(ExamineDetailRequest_17Item_Examine_Process *)proces {
    _proces = proces;
    self.introductionView.nameLabel.text = _proces.name;
    self.finishImageView.image = _proces.isFinish.boolValue ?[UIImage imageNamed:@"作业-已完成标签"] : [UIImage imageNamed:@"未成标签"];
    if (_proces.stageID.integerValue == 0){
        self.introductionView.statusImageView.hidden = YES;
//        self.introductionView.startTimeLabel.hidden = YES;
    }else {
        self.introductionView.statusImageView.hidden = _proces.status.boolValue;
//        self.introductionView.startTimeLabel.hidden = NO;
        if (_proces.isMockFold.boolValue) {
            self.enterImageView.image = [UIImage imageNamed:@"第二阶段收起箭头"];
        }else{
            self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
        }
        self.introductionView.startTimeLabel.text = [NSString stringWithFormat:@"开始时间: %@",_proces.startDate];
    }
    if (isEmpty(_proces.startDate)) {
        self.introductionView.startTimeLabel.hidden = YES;
    }else {
        self.introductionView.startTimeLabel.hidden = NO;
    }
    self.enterImageView.hidden = (_proces.procesID.integerValue == 304 || _proces.procesID.integerValue == 1003) ? YES : NO;
    if (_proces.procesID.integerValue == 1003) {
        self.scoreLabel.hidden = NO;
        self.finishImageView.hidden = YES;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分",_proces.userScore];
    }else {
        self.finishImageView.hidden = NO;
        self.scoreLabel.hidden = YES;
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}
@end
