//
//  YXLoadView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

@interface YXMinuteView : UIView

@end

@implementation YXMinuteView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI{
    UIImageView *handImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.5f, 4.0f, 17, 3.0f)];
    handImageView.image = [UIImage imageNamed:@"长针"];
    [self addSubview:handImageView];
}
@end

@interface YXHourView : UIView

@end

@implementation YXHourView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI{
    UIImageView *handImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.5f, 3.0f, 14.0f)];
    handImageView.image = [UIImage imageNamed:@"短针"];
    [self addSubview:handImageView];
}

@end


#import "YXLoadView.h"
@interface YXLoadView(){
    YXMinuteView *_minuteHand;
    YXHourView *_hourHand;
    double imageviewAngle;
    BOOL _isRuning;
    UIView *_ringView;
}
@end

@implementation YXLoadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    _ringView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11.0f, 11.0f)];
    _ringView.backgroundColor = [UIColor clearColor];
    _ringView.layer.cornerRadius = 5.5f;
    _ringView.layer.borderWidth = 3.0f;
    _ringView.center = self.center;
    _ringView.layer.borderColor = [UIColor colorWithHexString:@"2d87cf"].CGColor;
    [self addSubview:_ringView];
    
    _minuteHand = [[YXMinuteView alloc] init];
    _minuteHand.frame = CGRectMake(0.0f, 0.0f, 21.5f, 11.0f);
    _minuteHand.center = self.center;
    _minuteHand.layer.shouldRasterize = YES;
    [self setAnchor:CGPointMake(0.0f, 0.5f) forView:_minuteHand];
    [self addSubview:_minuteHand];
    
    _hourHand = [[YXHourView alloc] init];
    _hourHand.frame = CGRectMake(0.0f, 0.0f, 11.0f, 17.5);
    _hourHand.center = self.center;
    _hourHand.layer.shouldRasterize = YES;
    [self setAnchor:CGPointMake(0.5f,0.0f) forView:_hourHand];
    [self addSubview:_hourHand];
    imageviewAngle = 0.0f;
    _isRuning = NO;
}

- (void)setAnchor:(CGPoint)aPoint forView:(UIView *)aView {
    aView.layer.anchorPoint = aPoint;
    aView.layer.position = CGPointMake(aView.layer.position.x + (aPoint.x - aView.layer.anchorPoint.x) * aView.bounds.size.width, aView.layer.position.y + (aPoint.y - aView.layer.anchorPoint.y) * aView.bounds.size.height);
}
- (void)startAnimate{
    if (!_isRuning) {
        _isRuning = YES;
        [self rorateAnimatetion];
    }
}
- (void)stopAnimate{
    _isRuning = NO;
}
- (void)rorateAnimatetion
{
    if(_isRuning == YES)
    {
        [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _hourHand.transform = CGAffineTransformRotate(_hourHand.transform, M_PI / 60.0f);
            _minuteHand.transform = CGAffineTransformRotate(_minuteHand.transform, M_PI);
        }completion:^(BOOL finished) {
            [self rorateAnimatetion];
        }];
    }
}
@end
