//
//  YXLoginTopView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginTopView.h"

@interface YXLoginTopView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titileLabel;
@property (nonatomic, strong) UILabel *versionLabel;

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
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
    [self addSubview:self.logoImageView];
    
    self.titileLabel = [[UILabel alloc] init];
    self.titileLabel.text = @"良师通";
    self.titileLabel.font = [UIFont systemFontOfSize:24];
    [self addSubview:self.titileLabel];
    
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.font = [UIFont systemFontOfSize:16];
    self.versionLabel.text = @"V2.0";
    [self addSubview:self.versionLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(([UIScreen mainScreen].bounds.size.height - 371) * 0.44);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(26);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.titileLabel.mas_bottom).offset(11);
    }];
    
}

@end
