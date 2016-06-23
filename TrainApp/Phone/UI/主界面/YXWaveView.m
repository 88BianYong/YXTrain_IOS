//
//  YXWaveView.m
//  test
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWaveView.h"

@interface YXSingleWaveView : UIView
@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, strong) UIColor *waveColor;
@end

@implementation YXSingleWaveView
- (void)drawRect:(CGRect)rect{
    NSInteger stepCount = 8;
    CGFloat stepWidth = rect.size.width/stepCount;
    CGFloat bottomY = rect.size.height - self.bottomHeight;
    CGFloat topY = rect.size.height - self.topHeight;
    CGFloat baseY = (self.topHeight-self.bottomHeight)/2+topY;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, baseY)];
    for (int i=0; i<stepCount; i++) {
        if (i%2 == 0) {
            [path addQuadCurveToPoint:CGPointMake(stepWidth*(i+1), baseY) controlPoint:CGPointMake(stepWidth/2+stepWidth*i, topY)];
        }else{
            [path addQuadCurveToPoint:CGPointMake(stepWidth*(i+1), baseY) controlPoint:CGPointMake(stepWidth/2+stepWidth*i, bottomY)];
        }
    }
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, bottomY)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [self.waveColor setFill];
    CGContextFillPath(context);
}
@end

@interface YXWaveView()
@property (nonatomic, assign) BOOL layoutDone;
@property (nonatomic, strong) YXSingleWaveView *v1;
@property (nonatomic, strong) YXSingleWaveView *v2;
@end

@implementation YXWaveView

- (void)layoutSubviews{
    if (self.layoutDone) {
        return;
    }
    [self setupUI];
    [self setupObservers];
    self.layoutDone = YES;
}

- (void)setupUI{
    [self.v1 removeFromSuperview];
    [self.v2 removeFromSuperview];
    YXSingleWaveView *v1 = [[YXSingleWaveView alloc]initWithFrame:CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width*2, self.bounds.size.height)];
    v1.backgroundColor = [UIColor clearColor];
    v1.topHeight = 20;
    v1.bottomHeight = 0;
    v1.waveColor = [UIColor colorWithHexString:@"f2f4f7"];
    
    YXSingleWaveView *v2 = [[YXSingleWaveView alloc]initWithFrame:CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width*2, self.bounds.size.height)];
    v2.backgroundColor = [UIColor clearColor];
    v2.topHeight = 35;
    v2.bottomHeight = 0;
    v2.waveColor = [UIColor colorWithHexString:@"f8f9fd"];
    
    self.v1 = v1;
    self.v2 = v2;
    [self addSubview:v2];
    [self addSubview:v1];
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
        self.v1.frame = CGRectMake(0, 0, self.v1.bounds.size.width, self.v1.bounds.size.height);
    } completion:nil];
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
        self.v2.frame = CGRectMake(0, 0, self.v2.bounds.size.width, self.v2.bounds.size.height);
    } completion:nil];
}

- (void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self startAnimation];
    }];
}

- (void)startAnimation{
    // cell 重用的时候动画会自动停止，再次启动动画也不起作用，没办法，只能先remove v1，v2，然后重新初始化
    [self setupUI];
}

@end
