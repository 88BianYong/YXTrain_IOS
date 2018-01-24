//
//  YXCircleView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCircleView.h"
#import "WCGraintCircleLayer.h"
#define degressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式
@interface YXCircleView ()
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CALayer *gradientLayer;
@end
@implementation YXCircleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lineWidth = 5.0f;
        [self setupUI];
    }
    return self;
}
#pragma mark - set
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
     self.progressLayer.strokeEnd = _progress;
}
#pragma mark - setupUI
- (void)setupUI {
    CGRect rect = CGRectMake(0,0,CGRectGetWidth(self.bounds) - 2 * self.lineWidth, CGRectGetHeight(self.bounds) - 2 * self.lineWidth);
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    self.progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    self.progressLayer.frame = rect;
    self.progressLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    self.progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    self.progressLayer.strokeColor = [[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    self.progressLayer.opacity = 1.0f; //背景颜色的透明度
    self.progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    self.progressLayer.lineWidth = self.lineWidth;//线的宽度
    self.progressLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
    [self.layer addSublayer:self.progressLayer];
    //生成渐变色
    self.gradientLayer = [CALayer layer];
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.9, @1];
    leftLayer.colors = @[(id)[UIColor colorWithHexString:@"40d5fa"].CGColor, (id)[UIColor colorWithHexString:@"3c9df5"].CGColor];
    [self.gradientLayer addSublayer:leftLayer];
    
    //右侧渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    rightLayer.locations = @[@0.3, @0.9, @1];
    rightLayer.colors = @[(id)[UIColor colorWithHexString:@"40d5fa"].CGColor, (id)[UIColor colorWithHexString:@"3c9df5"].CGColor];
    [self.gradientLayer addSublayer:rightLayer];
    
    [self.layer setMask:self.progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:self.gradientLayer];
}
@end
