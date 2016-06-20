//
//  YXSlideProgressView.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXSlideProgressView.h"

@interface YXSlideProgressView()
@property (nonatomic, strong) UIImageView *thumbNormalView;


@property (nonatomic, strong) UIView *wholeProgressView;
@property (nonatomic, strong) UIView *playProgressView;
@property (nonatomic, strong) UIView *bufferProgressView;
@end

@implementation YXSlideProgressView {
    UIImage *_iconImage;
}
- (id)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.bSliding = NO;
    
    self.wholeProgressView = [[UIView alloc] init];
    self.wholeProgressView.backgroundColor = [UIColor colorWithHexString:@"#868686"];
    [self addSubview:self.wholeProgressView];
    self.wholeProgressView.userInteractionEnabled = NO;
    
    self.bufferProgressView = [[UIView alloc] init];
    self.bufferProgressView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bufferProgressView];
    self.bufferProgressView.userInteractionEnabled = NO;
    
    self.playProgressView = [[UIView alloc] init];
    self.playProgressView.backgroundColor = [UIColor colorWithHexString:@"2c97dd"];
    [self addSubview:self.playProgressView];
    self.playProgressView.userInteractionEnabled = NO;
    
    _iconImage = [UIImage imageNamed:@"03动态详情页UI-附件全屏浏览-未按-修改版"];
    
    self.thumbNormalView = [[UIImageView alloc] init];
    self.thumbNormalView.frame = CGRectMake(0, 0, _iconImage.size.width, _iconImage.size.height);
    self.thumbNormalView.image = _iconImage;
    [self addSubview:self.thumbNormalView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#868686"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeLabel];
    
    [self.wholeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbNormalView.bounds.size.width * 0.5);
        make.centerY.mas_equalTo(@0);
        make.height.mas_equalTo(@2);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_right).mas_offset(20);
        //make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(@0);
        make.right.mas_equalTo(@-10);
    }];
}

- (void)layoutSubviews {
    [self updateUI];
    [super layoutSubviews];
}

- (void)updateUI {
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
    
    [self.thumbNormalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_iconImage.size.width, _iconImage.size.height));
        make.centerX.mas_equalTo(self.wholeProgressView.mas_left).mas_offset(self.wholeProgressView.bounds.size.width * self.playProgress);
        make.centerY.mas_equalTo(self.wholeProgressView.mas_centerY);
    }];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self timeString:self.duration * self.playProgress], [self timeString:self.duration]];
}

- (NSString *)timeString:(NSTimeInterval)time {
    int minute = (int)(time / 60);
    int second = ((int)time) % 60;
    NSString *ret = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    return ret;
}


#pragma mark - touch event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    DDLogWarn(@"%@", NSStringFromCGPoint(touchPoint));
    if (CGRectContainsPoint([self slidePointImageRect], touchPoint)) {
        self.bSliding = YES;
        self.thumbNormalView.image = [UIImage imageNamed:@"03动态详情页UI-附件全屏浏览-按下效果-修改版"];
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat startX = self.wholeProgressView.bounds.origin.x;
    CGFloat endX = self.wholeProgressView.bounds.origin.x + self.wholeProgressView.bounds.size.width;
    touchPoint.x = MAX(startX, touchPoint.x);
    touchPoint.x = MIN(endX, touchPoint.x);
    
    self.playProgress = (touchPoint.x - startX) / (endX - startX);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsLayout];
    self.bSliding = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.bSliding = NO;
    self.thumbNormalView.image = [UIImage imageNamed:@"03动态详情页UI-附件全屏浏览-未按-修改版"];
}

- (CGRect)slidePointImageRect {
    CGRect rect = self.thumbNormalView.frame;
    rect.size.width  = rect.size.width + 8;//拖动按钮的区域增加8个像素
    rect.size.height = rect.size.height + 8;
    NSLog(@"%@", NSStringFromCGRect(rect));
    return rect;
}

@end
