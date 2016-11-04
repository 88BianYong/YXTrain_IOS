//
//  ActivityPlayBottomView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityPlayBottomView.h"
@interface ActivityPlayBottomView()
@property (nonatomic, strong) UILabel *timeLabel;

@end
@implementation ActivityPlayBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI{
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playPauseButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.playPauseButton];
    
    self.rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rotateButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.rotateButton];
    self.slideProgressView = [[YXSlideProgressView alloc] init];
    self.slideProgressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.slideProgressView];

}

- (void)setupLayout{
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10.0f);
    }];
    
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10.0f);
    }];
    [self.slideProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(55.0f);
        make.right.mas_equalTo(-80);
        make.top.bottom.mas_equalTo(@0);
    }];
    [self.slideProgressView updateUI];
}

#pragma mark - set
- (void)setIsFullscreen:(BOOL)isFullscreen{
    _isFullscreen = isFullscreen;
    if (_isFullscreen) {
        
    }else{
        
    }
}
@end
