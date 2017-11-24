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
@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *projectStatusLabel;
@property (nonatomic, strong) UILabel *scorePromptLabel;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *statusPromptLabel;
@end
@implementation MasterHomeTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    
    self.projectStatusLabel = [[UILabel alloc] init];
    self.projectStatusLabel.font = [UIFont systemFontOfSize:12.0f];
    self.projectStatusLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    [self addSubview:self.projectStatusLabel];
    
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
    self.statusPromptLabel.text = @"当前得分";
    [self addSubview:self.statusPromptLabel];
}
- (void)setupLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self);
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(15.0f);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.projectStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(54.0f);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.mas_top).offset(54.0f);
        make.left.equalTo(self.mas_left);
    }];
    
    [self.scorePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scoreLabel.mas_centerX);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.mas_top).offset(54.0f);
        make.right.equalTo(self.mas_right);
    }];
    [self.statusPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusLabel.mas_centerX);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(10.0f);
    }];
}

- (void)reloadHeaderViewContent:(NSString *)score withPass:(NSInteger)pass {
    NSString *contentString = [NSString stringWithFormat:@"%@分",score];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attString addAttribute:NSFontAttributeName value: [UIFont fontWithName:YXFontMetro_Medium size:23.0f] range:NSMakeRange(0, contentString.length - 1)];
    self.scoreLabel.attributedText = attString;
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
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [dateFormater dateFromString:[LSTSharedInstance sharedInstance].trainManager.currentProject.endDate];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    
    self.projectStatusLabel.text = [NSString stringWithFormat:@"%@-%@ %@",[LSTSharedInstance sharedInstance].trainManager.currentProject.startDate,currentDateString,statusString];
}
@end
