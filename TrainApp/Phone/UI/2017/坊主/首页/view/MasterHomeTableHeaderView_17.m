//
//  MasterHomeTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeTableHeaderView_17.h"
#import "MasterWaveView_17.h"
@interface MasterHomeTableHeaderView_17 ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MasterWaveView_17 *waveView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scorePromptLabel;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *statusPromptLabel;

@property (nonatomic, strong) UIButton *openButton;

@property (nonatomic, strong) UILabel *passDescLabel;
@property (nonatomic, strong) UILabel *delayDescLabel;
@property (nonatomic, strong) UILabel *projectStatusLabel;


@end
@implementation MasterHomeTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"导航栏-"]];
    [self addSubview:self.imageView];
    self.waveView = [[MasterWaveView_17 alloc]init];
    self.waveView.userInteractionEnabled = NO;
    self.waveView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.waveView];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont systemFontOfSize:18.0f];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:self.scoreLabel];
    
    self.scorePromptLabel = [[UILabel alloc] init];
    self.scorePromptLabel.font = [UIFont systemFontOfSize:12.0f];
    self.scorePromptLabel.textColor = [[UIColor colorWithHexString:@"ffffff"] colorWithAlphaComponent:0.6f];
    self.scorePromptLabel.text = @"当前得分";
    [self addSubview:self.scorePromptLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:18.0f];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:self.statusLabel];
    
    self.statusPromptLabel = [[UILabel alloc] init];
    self.statusPromptLabel.font = [UIFont systemFontOfSize:12.0f];
    self.statusPromptLabel.textColor = [[UIColor colorWithHexString:@"ffffff"] colorWithAlphaComponent:0.6f];
    self.statusPromptLabel.text = @"考核结果";
    [self addSubview:self.statusPromptLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"0067b8"];
    [self addSubview:self.lineView];
    
    
    self.openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.openButton setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
    [self.openButton setImage:[UIImage imageNamed:@"收起A"] forState:UIControlStateSelected];
    self.openButton.selected = YES;
    WEAK_SELF
    [[self.openButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.openButton.selected = !self.openButton.selected;
        [self openProjectScoreAndProjectTime:self.openButton.selected];
    }];
    [self addSubview:self.openButton];
    
    self.passDescLabel = [[UILabel alloc] init];
    self.passDescLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.passDescLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.passDescLabel];
    
    self.delayDescLabel = [[UILabel alloc] init];
    self.delayDescLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.delayDescLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.delayDescLabel];
    
    self.projectStatusLabel = [[UILabel alloc] init];
    self.projectStatusLabel.font = [UIFont systemFontOfSize:12.0f];
    self.projectStatusLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.projectStatusLabel];
    
}
- (void)setupLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self);
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(230.0f);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(1.0f, 40.0f));
        make.top.equalTo(self.mas_top).offset(35.5f);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.mas_top).offset(35.0f);
        make.left.equalTo(self.mas_left);
    }];
    
    [self.scorePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scoreLabel.mas_centerX);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.mas_top).offset(35.0f);
        make.right.equalTo(self.mas_right);
    }];
    [self.statusPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusLabel.mas_centerX);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.passDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.lineView.mas_bottom).offset(54.0f);
    }];
    
    [self.delayDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.passDescLabel.mas_bottom).offset(6.0f);
    }];
    
    [self.projectStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.delayDescLabel.mas_bottom).offset(12.0f);
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-10.0f);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
}

- (void)reloadHeaderViewContent:(NSString *)score
                 withPassString:(NSString *)passString
               withDeladyString:(NSString *)delayString
                       withPass:(NSInteger)pass {
    NSString *contentString = [NSString stringWithFormat:@"%@分",score];
    self.scoreLabel.text = contentString;
    if (pass == 0) {
        self.statusLabel.text = @"未通过";
    }else if (pass == 1) {
        self.statusLabel.text = @"暂未通过";
    }else {
        self.statusLabel.text = @"通过";
    }
    NSString *statusString = @"未开始";
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 0) {
        statusString = @"已结束";
    }else if ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 1){
        statusString = @"进行中";
    }
    self.passDescLabel.text = passString?:@"";
    self.delayDescLabel .text = delayString?:@"";
    
    self.projectStatusLabel.text = [NSString stringWithFormat:@"%@-%@ %@",[LSTSharedInstance sharedInstance].trainManager.currentProject.startDate,[LSTSharedInstance sharedInstance].trainManager.currentProject.endDate,statusString];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.openButton.selected) {
            self.openButton.selected = NO;
            [self openProjectScoreAndProjectTime:NO];
        }
    });
    
}

#pragma mark - open & close
- (void)openProjectScoreAndProjectTime:(BOOL)isOpen {
    self.delayDescLabel.hidden = !isOpen;
    self.projectStatusLabel.hidden = !isOpen;
    [self.waveView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (isOpen) {
            make.height.mas_offset(230.0f);
        }else {
            make.height.mas_offset(180.0f);
        }
    }];
    BLOCK_EXEC(self.masterHomeOpenCloseBlock,isOpen);
}
@end
