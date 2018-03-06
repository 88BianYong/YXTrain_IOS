//
//  MasterWaveView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterWaveView_17.h"
@interface MasterWaveView_17 ()
@property (nonatomic ,strong)CAShapeLayer * waveShapeLayer;
@property (nonatomic ,strong)CAShapeLayer * waveShapeLayerT;
@property (nonatomic, strong)CADisplayLink *waveDisplayLink;
@property (nonatomic, assign)CGFloat waveSpeed;
@property (nonatomic, assign)CGFloat offsetX;
@property (nonatomic, assign)CGFloat waveHeight;
@property (nonatomic, assign)CGFloat waveWidth;
@property (nonatomic, assign)CGFloat waveAmplitude;
@property (nonatomic, assign)CGFloat offsetXT;

@property (nonatomic, assign) BOOL isStartBool;
@end
@implementation MasterWaveView_17
-(void)dealloc{
    [self.waveDisplayLink invalidate];
    [self.waveDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.waveDisplayLink = nil;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.waveSpeed  = 0.1f;
    self.offsetX = 10.0f;
    self.waveHeight = 115.0f;
    self.waveWidth = kScreenWidth;
    self.waveAmplitude = 5.0f;
    self.offsetXT = 100.0f;
    if (!self.isStartBool) {
        [self wave];
    }
    self.isStartBool = YES;
}


- (void)wave {
    self.waveShapeLayerT = [CAShapeLayer layer];
    self.waveShapeLayerT.fillColor = [[UIColor colorWithHexString:@"dfe2e6"] colorWithAlphaComponent:0.2f].CGColor;
    [self.layer addSublayer:self.waveShapeLayerT];
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
    [self.layer addSublayer:self.waveShapeLayer];
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)getCurrentWave {
    self.offsetX += self.waveSpeed;
    //声明第一条波曲线的路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始点
    CGPathMoveToPoint(path, nil, 0, self.waveHeight - 50.0f);
    
    CGFloat y = 10.f;
    //第一个波纹的公式
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        y = self.waveAmplitude * sin(1.0f/30.0f * x + self.offsetX) + self.waveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
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
    CGPathMoveToPoint(pathT, nil, 0, self.waveHeight+100 - 50.0f);
    CGFloat yT = 10.f;
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        yT = self.waveAmplitude * sin(1.0f/30.0f * x + self.offsetXT) + self.waveHeight;
        CGPathAddLineToPoint(pathT, nil, x, yT-13.0f);
    }
    CGPathAddLineToPoint(pathT, nil, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(pathT, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(pathT);
    self.waveShapeLayerT.path = pathT;
    CGPathRelease(pathT);
}

@end
