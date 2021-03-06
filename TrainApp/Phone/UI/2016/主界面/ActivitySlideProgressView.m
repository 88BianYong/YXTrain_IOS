//
//  ActivitySlideProgressView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivitySlideProgressView.h"
#import "YXGradientView.h"
@interface ActivitySlideProgressView ()
@property (nonatomic, strong) UIView *playProgressView;
@property (nonatomic, strong) UIView *bufferProgressView;
@end
@implementation ActivitySlideProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
        
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.wholeProgressView = [[UIView alloc] init];
    self.wholeProgressView.backgroundColor = [UIColor colorWithHexString:@"#919191"];
    [self addSubview:self.wholeProgressView];
    self.wholeProgressView.userInteractionEnabled = NO;
    
    self.bufferProgressView = [[UIView alloc] init];
    self.bufferProgressView.backgroundColor = [UIColor colorWithHexString:@"8ec2ef"];
    [self addSubview:self.bufferProgressView];
    self.bufferProgressView.userInteractionEnabled = NO;
    
    self.playProgressView = [[YXGradientView alloc]initWithStartColor:[UIColor colorWithHexString:@"00d8ff"] endColor:[UIColor colorWithHexString:@"2d87f9"] orientation:YXGradientLeftToRight];;
    [self addSubview:self.playProgressView];
    self.playProgressView.userInteractionEnabled = NO;
}

- (void)setupLayout {
    [self.wholeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(@0);
        make.height.mas_equalTo(@3.0f);
        make.right.equalTo(self.mas_right);
    }];
    [self.bufferProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self.bufferProgress).priorityHigh();
    }];
    
    [self.playProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self.playProgress).priorityHigh();
    }];
}
- (void)setPlayProgress:(CGFloat)playProgress {
    _playProgress = playProgress;
    [self.playProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self->_playProgress).priorityHigh();
    }];
}

- (void)setBufferProgress:(CGFloat)bufferProgress {
    _bufferProgress = bufferProgress;
    [self.bufferProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self->_bufferProgress).priorityHigh();
    }];

}
@end
