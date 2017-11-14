//
//  YXHomeworkPromptView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkPromptView.h"

@implementation YXHomeworkPromptView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.72f];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[LSTSharedInstance sharedInstance].trainManager.trainHelper.firstHomeworkImageName];
    [self addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"我知道了-按钮"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"我知道了-按钮点击态"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(removeSelfButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kScreenWidthScale(340.f));
        make.height.mas_offset(kScreenHeightScale(90.0f));
        make.top.equalTo(self.mas_top).offset(kScreenHeightScale(155.0f));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kScreenWidthScale(170.f));
        make.height.mas_offset(kScreenHeightScale(65.0f));
        make.top.equalTo(imageView.mas_bottom).offset(kScreenHeightScale(45.0f));
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)removeSelfButtonAction:(UIButton *)sender{
    [self removeFromSuperview];
}
@end
