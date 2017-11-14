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
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"导航栏-拷贝"]];
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
    self.statusPromptLabel.text = @"当前得分";
    [self addSubview:self.statusPromptLabel];
}
- (void)setupLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
}

- (void)reloadHeaderViewContent:(NSString *)score withPass:(BOOL)isPass {
    NSString *contentString = [NSString stringWithFormat:@"%@分",score];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attString addAttribute:NSFontAttributeName value: [UIFont fontWithName:YXFontMetro_Medium size:23.0f] range:NSMakeRange(0, contentString.length - 1)];
    self.scoreLabel.attributedText = attString;
    self.statusLabel.text = isPass ? @"通过" : @"暂未通过";
}
@end
