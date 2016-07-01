//
//  YXLoginTopView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginTopView.h"
#import "UIImageView+AnimationCompletion.h"

@interface YXLoginTopView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIImageView *titleImageView;

@end

@implementation YXLoginTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"logo_01"];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 40; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"logo_%.2d",i + 1]];
        [imageArray addObject:image];
    }
    self.logoImageView.animationImages = imageArray;
    self.logoImageView.animationDuration = 1.15;
    self.logoImageView.animationRepeatCount = 1;
    [self.logoImageView startAnimatingWithDelayTime:0.5 CompletionBlock:^(BOOL success) {
        //self.logoImageView.image = [UIImage imageNamed:@"logo_40"];
    }];
    [self addSubview:self.logoImageView];
    
    self.titleImageView = [[UIImageView alloc] init];
    self.titleImageView.image = [UIImage imageNamed:@"良师通"];
    [self addSubview:self.titleImageView];
    
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.font = [UIFont fontWithName:YXFontMetro_Italic size:16];
    self.versionLabel.textColor = [UIColor colorWithHexString:@"bbc2c9"];
    self.versionLabel.text = @"V2.0";
    [self addSubview:self.versionLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(([UIScreen mainScreen].bounds.size.height - 371) * 0.44 - 31);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(-5);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.titleImageView.mas_bottom).offset(11);
    }];
    
}

@end
