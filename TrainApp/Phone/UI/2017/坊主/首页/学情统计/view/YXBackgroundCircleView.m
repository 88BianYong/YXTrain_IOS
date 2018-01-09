//
//  YXBackgroundCircleView.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXBackgroundCircleView.h"
@interface YXBackgroundCircleView ()
@property (nonatomic, strong) CAShapeLayer *maskShapeLayer;

@end
@implementation YXBackgroundCircleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maskShapeLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(0,0,CGRectGetWidth(self.bounds) - 2 * 5.0f, CGRectGetHeight(self.bounds) - 2 * 5.0f);
        self.maskShapeLayer.bounds = rect;
        self.maskShapeLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        self.maskShapeLayer.strokeColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
        self.maskShapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.maskShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
        self.maskShapeLayer.lineWidth = 5.0f;
        self.maskShapeLayer.lineCap = kCALineCapRound;
        self.maskShapeLayer.strokeStart = 0.0f;
        self.maskShapeLayer.strokeEnd = 1.0f;
        [self.layer addSublayer:self.maskShapeLayer];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

@end
