//
//  YXLearningTableHeaderView_DeYang17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXLearningTableHeaderView_DeYang17.h"
@interface LearningTableHeaderBottomDeYangView :UIView
@property (nonatomic, strong) UILabel *label;
@end
@implementation LearningTableHeaderBottomDeYangView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *vLineView = [[UIView alloc] init];
        vLineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
        vLineView.layer.cornerRadius = 1.0f;
        [self addSubview:vLineView];
        [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.size.mas_offset(CGSizeMake(2.0f, 13.0f));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.text = @"学习流程";
        self.label.textColor = [UIColor colorWithHexString:@"#334466"];
        self.label.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vLineView.mas_right).offset(7.0f);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIView *hLineView = [[UIView alloc] init];
        hLineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self addSubview:hLineView];
        [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}
@end

@interface YXLearningTableHeaderView_DeYang17 ()
@property (nonatomic, strong) LearningTableHeaderBottomDeYangView *topView;
@property (nonatomic, strong) UIView *projectView;
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreNameLabel;
@property (nonatomic, strong) UILabel *noticeBriefLabel;
@property (nonatomic, strong) UIImageView *noticeBriefImageView;

@property (nonatomic, strong) LearningTableHeaderBottomDeYangView *bottomView;
@property (nonatomic, strong) UIButton *myScoreButton;
@property (nonatomic, strong) UIButton *noticeBriefButton;
@end
@implementation YXLearningTableHeaderView_DeYang17

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setIsPass:(NSString *)isPass{
    _isPass = isPass;
    NSString *statusString = @"未开始";
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 0) {
        statusString = @"已结束";
    }else if ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 1){
        statusString = @"进行中";
    }
    self.projectLabel.text = [NSString stringWithFormat:@"%@-%@ %@",[LSTSharedInstance sharedInstance].trainManager.currentProject.startDate,[LSTSharedInstance sharedInstance].trainManager.currentProject.endDate,statusString];
    if (_isPass.integerValue == 0) {
        self.scoreLabel.text = @"未通过";
    }else if (_isPass.integerValue == 1) {
        self.scoreLabel.text = @"暂未通过";
    }else {
        self.scoreLabel.text = @"已通过";
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[LearningTableHeaderBottomDeYangView alloc] init];
    self.topView.label.text = @"项目时间";
    [self addSubview:self.topView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    
    self.projectView = [[UIView alloc] init];
    self.projectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.projectView];
    
    self.projectLabel = [[UILabel alloc] init];
    self.projectLabel.font = [UIFont systemFontOfSize:14.0f];
    self.projectLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.projectLabel];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor =[UIColor whiteColor];
    [self addSubview:self.containerView];
    
    self.myScoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myScoreButton.enabled = NO;
    [self.containerView addSubview:self.myScoreButton];
    
    self.noticeBriefButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WEAK_SELF

    [[self.noticeBriefButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.learningMyScoreCompleteBlock,NO);
    }];
    [self.containerView addSubview:self.noticeBriefButton];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:22.0f];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.text = @"70";
    [self.containerView addSubview:self.scoreLabel];
    
    self.scoreNameLabel = [[UILabel alloc] init];
    self.scoreNameLabel.text = @"我的成绩";
    self.scoreNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.scoreNameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.scoreNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.scoreNameLabel];
    
    self.noticeBriefImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"简报"]];
    [self.containerView addSubview:self.noticeBriefImageView];
    
    self.noticeBriefLabel = [[UILabel alloc] init];
    self.noticeBriefLabel.text = @"通知简报";
    self.noticeBriefLabel.font = [UIFont systemFontOfSize:13.0f];
    self.noticeBriefLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.noticeBriefLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.noticeBriefLabel];
    
    self.bottomView = [[LearningTableHeaderBottomDeYangView alloc] init];
    [self addSubview:self.bottomView];
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    [self.projectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_offset(45.0f);
    }];
    
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.mas_offset(45.0f);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.projectLabel.mas_bottom).offset(5.0f);
        make.height.mas_offset(100.0f);
    }];
    [self.myScoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.containerView.mas_left);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(1.0f/2.0f);
    }];
    [self.noticeBriefButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(1.0f/2.0f);
    }];
    
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(1.0f/2.0f);
        make.bottom.equalTo(self.containerView.mas_centerY).offset(6.0f);
    }];
    
    [self.scoreNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scoreLabel.mas_width);
        make.top.equalTo(self.containerView.mas_centerY).offset(9.0f);
        make.centerX.equalTo(self.scoreLabel.mas_centerX);
    }];
    
    [self.noticeBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scoreNameLabel.mas_width);
        make.top.equalTo(self.containerView.mas_centerY).offset(9.0f);
        make.right.equalTo(self.containerView.mas_right);
    }];
    
    [self.noticeBriefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noticeBriefLabel.mas_centerX);
        make.bottom.equalTo(self.containerView.mas_centerY).offset(-1.0f);
        make.size.mas_offset(CGSizeMake(27.0f, 27.0f));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.containerView.mas_bottom).offset(5.0f);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
@end
