//
//  ActivityPlayExceptionView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityPlayExceptionView.h"
@interface ActivityPlayExceptionView ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation ActivityPlayExceptionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
        self.backgroundColor = [UIColor colorWithHexString:@"334466"];

    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundView = [[UIView alloc] init];
    [self addSubview:self.backgroundView];
    
    self.exceptionLabel = [[UILabel alloc] init];
    self.exceptionLabel.textColor = [UIColor whiteColor];
    self.exceptionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.exceptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:self.exceptionLabel];
    
    self.exceptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exceptionButton.layer.cornerRadius = YXTrainCornerRadii;
    self.exceptionButton.layer.borderColor = [UIColor colorWithHexString:@"78c4ff"].CGColor;
    self.exceptionButton.layer.borderWidth = 1.0f;
    self.exceptionButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.exceptionButton setTitleColor:[UIColor colorWithHexString:@"78c4ff"] forState:UIControlStateNormal];
    [self.backgroundView addSubview:self.exceptionButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"视频全屏－返回按钮点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.backButton];
}

- (void)setupLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_offset(59.0f);
    }];
    [self.exceptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView.mas_centerX);
        make.top.equalTo(self.backgroundView.mas_top);
    }];
    [self.exceptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(95.0f, 24.0f));
        make.centerX.equalTo(self.backgroundView.mas_centerX);
        make.top.equalTo(self.exceptionLabel.mas_bottom).offset(21.0f);
        make.bottom.equalTo(self.backgroundView.mas_bottom);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_offset(CGSizeMake(50.0f, 50.0f));
    }];
}
@end
