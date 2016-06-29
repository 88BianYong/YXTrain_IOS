//
//  YXCourseFilterBgView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseFilterBgView.h"

@interface YXTriangleView : UIView
@end
@implementation YXTriangleView
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextClosePath(context);
    [[UIColor whiteColor]setFill];
    CGContextFillPath(context);
}
@end

@interface YXCourseFilterBgView()
@property (nonatomic, strong) YXTriangleView *triangleView;
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, assign) CGFloat triangleX;
@end

@implementation YXCourseFilterBgView

- (instancetype)initWithFrame:(CGRect)frame triangleX:(CGFloat)x{
    if (self = [super initWithFrame:frame]) {
        self.triangleX = x;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.triangleView = [[YXTriangleView alloc]initWithFrame:CGRectMake(self.triangleX-8, 0, 16, 7)];
    self.triangleView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.triangleView];
    self.contentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, self.bounds.size.width, self.bounds.size.height-7)];
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    self.contentBgView.layer.cornerRadius = 2;
    self.contentBgView.clipsToBounds = YES;
    [self addSubview:self.contentBgView];
}

@end
