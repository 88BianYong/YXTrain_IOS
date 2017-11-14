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
//@property (nonatomic, assign) BOOL layoutDone;
//@property (nonatomic, strong) YXSingleWaveView *v1;
//@property (nonatomic, strong) YXSingleWaveView *v2;
@property (nonatomic ,strong)CAShapeLayer * waveShapeLayer;
@property (nonatomic ,strong)CAShapeLayer * waveShapeLayerT;
@property (nonatomic, strong)CADisplayLink *waveDisplayLink;
@property (nonatomic, assign)CGFloat waveSpeed;
@property (nonatomic, assign)CGFloat offsetX;
@property (nonatomic, assign)CGFloat waveHeight;
@property (nonatomic, assign)CGFloat waveWidth;
@property (nonatomic, assign)CGFloat waveAmplitude;
@property (nonatomic, assign)CGFloat offsetXT;



@end

@implementation YXWaveView

//- (void)layoutSubviews{
//    if (self.layoutDone) {
//        return;
//    }
//    self.clipsToBounds = YES;
//    [self setupUI];
//    [self setupObservers];
//    self.layoutDone = YES;
//}
//
//- (void)setupUI{
//    [self.v1 removeFromSuperview];
//    [self.v2 removeFromSuperview];
//    YXSingleWaveView *v1 = [[YXSingleWaveView alloc]initWithFrame:CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width*2, self.bounds.size.height)];
//    v1.backgroundColor = [UIColor clearColor];
//    v1.topHeight = 20;
//    v1.bottomHeight = 0;
//    v1.waveColor = [UIColor colorWithHexString:@"f2f4f7"];
//    
//    YXSingleWaveView *v2 = [[YXSingleWaveView alloc]initWithFrame:CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width*2, self.bounds.size.height)];
//    v2.backgroundColor = [UIColor clearColor];
//    v2.topHeight = 35;
//    v2.bottomHeight = 0;
//    v2.waveColor = [UIColor colorWithHexString:@"f8f9fd"];
//    
//    self.v1 = v1;
//    self.v2 = v2;
//    [self addSubview:v2];
//    [self addSubview:v1];
//    
//    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
//        self.v1.frame = CGRectMake(0, 0, self.v1.bounds.size.width, self.v1.bounds.size.height);
//    } completion:nil];
//    [UIView animateWithDuration:7 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
//        self.v2.frame = CGRectMake(0, 0, self.v2.bounds.size.width, self.v2.bounds.size.height);
//    } completion:nil];
//}
//
//- (void)setupObservers{
//    WEAK_SELF
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]subscribeNext:^(id x) {
//        STRONG_SELF
//        [self startAnimation];
//    }];
//}
//
//- (void)startAnimation{
//    // cell 重用的时候动画会自动停止，再次启动动画也不起作用，没办法，只能先remove v1，v2，然后重新初始化
//    [self setupUI];
//}
-(void)dealloc{
    [self.waveDisplayLink invalidate];
    [self.waveDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.waveDisplayLink = nil;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.waveSpeed  = 5.0f;
    self.offsetX = 10.0f;
    self.waveHeight = 100.0f;
    self.waveWidth = kScreenWidth;
    self.waveAmplitude = 10.0f;
    self.offsetXT = 100.0f;
    [self wave];
}


- (void)wave {
    /*
     *创建两个layer
     */
    
    self.waveShapeLayerT = [CAShapeLayer layer];
    self.waveShapeLayerT.fillColor = [UIColor colorWithHexString:@"f8f9fd"].CGColor;
    [self.layer addSublayer:self.waveShapeLayerT];
    
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = [UIColor colorWithHexString:@"f2f4f7"].CGColor;
    [self.layer addSublayer:self.waveShapeLayer];
    

    /*
     *CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。我们在应用中创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
     */
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)getCurrentWave {
    self.offsetX += self.waveSpeed;
    //声明第一条波曲线的路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始点
    CGPathMoveToPoint(path, nil, 0, self.waveHeight);
    
    CGFloat y = 0.f;
    //第一个波纹的公式
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        y = self.waveAmplitude * sin((300.0f * 1.5f / self.waveWidth) * (x * M_PI / 180) - self.offsetX * M_PI / 270) + self.waveHeight*1;
        CGPathAddLineToPoint(path, nil, x, y);
        x++;
    }
    //把绘图信息添加到路径里
    CGPathAddLineToPoint(path, nil, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    //结束绘图信息
    CGPathCloseSubpath(path);
    
    self.waveShapeLayer.path = path;
    //释放绘图路径
    CGPathRelease(path);
    
    /*
     *  第二个
     */
    self.offsetXT += self.waveSpeed;
    CGMutablePathRef pathT = CGPathCreateMutable();
    CGPathMoveToPoint(pathT, nil, 0, self.waveHeight+100);
    
    CGFloat yT = 0.f;
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        yT = self.waveAmplitude * sin((260.0f * 1.5f / self.waveWidth) * (x * M_PI / 180) - self.offsetXT * M_PI / 180) + self.waveHeight;
        CGPathAddLineToPoint(pathT, nil, x, yT-10);
    }
    CGPathAddLineToPoint(pathT, nil, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(pathT, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(pathT);
    self.waveShapeLayerT.path = pathT;
    CGPathRelease(pathT);
}

@end
