//
//  VideoBeginningTopView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/6/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoBeginningTopView.h"

@implementation VideoBeginningTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.backButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
}
@end
