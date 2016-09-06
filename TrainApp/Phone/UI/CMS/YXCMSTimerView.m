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
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@end

@implementation YXCMSTimerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
        _secondsLabel.backgroundColor = [UIColor whiteColor];
        _secondsLabel.textColor = [UIColor blackColor];
        _secondsLabel.clipsToBounds = YES;
        _secondsLabel.layer.cornerRadius = 15.f;
        [self addSubview:_secondsLabel];
        [_secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
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