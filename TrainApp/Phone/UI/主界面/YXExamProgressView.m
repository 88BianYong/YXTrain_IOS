//
//  YXExamProgressView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamProgressView.h"
#import "YXGradientView.h"

static const CGFloat kTotalDuration = 1.f;

@interface YXExamProgressView()
@property (nonatomic, strong) YXGradientView *gradientView;
@end

@implementation YXExamProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];    
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    self.gradientView = [[YXGradientView alloc]initWithStartColor:[UIColor colorWithHexString:@"40d5fa"] endColor:[UIColor colorWithHexString:@"4688f1"] orientation:YXGradientLeftToRight];
    self.gradientView.layer.cornerRadius = 3;
    self.gradientView.clipsToBounds = YES;
    [self addSubview:self.gradientView];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progress = MAX(_progress, 0);
    _progress = MIN(_progress, 1);
    [self.gradientView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0);
    }];
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kTotalDuration*self->_progress animations:^{
            [self.gradientView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(self.mas_width).multipliedBy(self->_progress);
            }];
            [self layoutIfNeeded];
        }];
    });
}

@end
