//
//  YXCMSTimerView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCMSTimerView.h"

@interface YXCMSTimerView ()

@property (nonatomic, strong) UILabel *secondsLabel;
@property (nonatomic, strong) UILabel *skipLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger seconds;

@end

@implementation YXCMSTimerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textColor = [UIColor whiteColor];
        _secondsLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_secondsLabel];
        [_secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10.0f);
        }];
        
        _skipLabel = [[UILabel alloc] init];
        _skipLabel.font = [UIFont systemFontOfSize:12.0f];
        _skipLabel.textColor = [UIColor colorWithHexString:@"0067be"];
        _skipLabel.text = @"跳过";
        [self addSubview:_skipLabel];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头"]];
        [self addSubview:_imageView];
        
        
        [_skipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self->_imageView.mas_left).offset(-3.0f);
        }];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.width.mas_offset(8.0f);
            make.height.mas_offset(17.0f);
        }];
        
    }
    return self;
}

- (void)startWithSeconds:(NSInteger)seconds
{
    self.seconds = seconds;
    [self startTimer];
}

- (void)showTimeSeconds
{
    self.secondsLabel.text = [NSString stringWithFormat:@"%@", @(self.seconds)];
}

- (void)startTimer
{
    [self showTimeSeconds];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)countdownTimer
{
    self.seconds--;
    if (self.seconds <= 0) {
        [self stopTimer];
        return;
    }
    [self showTimeSeconds];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    self.seconds = 0;
    BLOCK_EXEC(self.stopTimerBlock);
}
@end
