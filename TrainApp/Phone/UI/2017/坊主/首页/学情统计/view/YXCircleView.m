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
@property (nonatomic, strong) CAShapeLayer *maskShapeLayer;
@property (nonatomic, strong) WCGraintCircleLayer * graintlayer;
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
    self.graintlayer.progress = _progress;
    self.titleLabel.text = [NSString stringWithFormat:@"%0.2f%%",_progress *100.0f];
}
#pragma mark - setupUI
- (void)setupUI {
    self.maskShapeLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(0,0,CGRectGetWidth(self.bounds) - 2 * self.lineWidth, CGRectGetHeight(self.bounds) - 2 * self.lineWidth);
    self.maskShapeLayer.bounds = rect;
    self.maskShapeLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    self.maskShapeLayer.strokeColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
    self.maskShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
    self.maskShapeLayer.lineWidth = self.lineWidth;
    self.maskShapeLayer.lineCap = kCALineCapRound;
    self.maskShapeLayer.strokeStart = 0.0f;
    self.maskShapeLayer.strokeEnd = 1.0f;
    [self.layer addSublayer:self.maskShapeLayer];
    
    self.graintlayer = [[WCGraintCircleLayer alloc]
                        initGraintCircleWithBounds:self.bounds Position:self.center
                        FromColor:[UIColor colorWithHexString:@"40d5fa"]
                        ToColor:[UIColor colorWithHexString:@"3c9df5"]
                        LineWidth:self.lineWidth];
    [self.layer addSublayer:self.graintlayer];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end
