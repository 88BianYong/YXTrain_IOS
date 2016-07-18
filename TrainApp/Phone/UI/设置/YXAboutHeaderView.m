//
//  YXAboutHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAboutHeaderView.h"

@implementation YXAboutHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_offset(5.0f);
    }];

    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logoImageView];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(58.0f/667.0f * height);
        make.height.width.mas_offset(100.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"良师通"];
    [self addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(26.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];  
    versionLabel.text = [NSString stringWithFormat:@"V%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    versionLabel.textColor = [UIColor colorWithHexString:@"bbc2c9"];
    versionLabel.font = [UIFont fontWithName:YXFontMetro_Italic size:16];
    [self addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleImageView.mas_bottom).offset(11.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];

}
@end
