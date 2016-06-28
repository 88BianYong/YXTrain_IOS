//
//  YXStoreLikeProgressView.m
//  MyTestTemplate
//
//  Created by Lei Cai on 6/28/16.
//  Copyright © 2016 yanxiu. All rights reserved.
//

#import "YXStoreLikeProgressView.h"

@implementation YXStoreLikeProgressView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path addArcWithCenter:CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5)
                    radius:MIN(rect.size.width, rect.size.height) * 0.5
                startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CGContextAddPath(context, path.CGPath);
    [[UIColor redColor] setFill];
    CGContextFillPath(context);
    
    path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5)
                    radius:MIN(rect.size.width -  20, rect.size.height) * 0.5
                startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CGContextAddPath(context, path.CGPath);
    [[UIColor whiteColor] setFill];
    CGContextFillPath(context);
    
    path = [UIBezierPath bezierPath];
    if (self.progress == 0) {
        [path addArcWithCenter:CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5)
                        radius:MIN(rect.size.width -  5, rect.size.height) * 0.5
                    startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    } else {
        [path addArcWithCenter:CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5)
                        radius:MIN(rect.size.width -  5, rect.size.height) * 0.5
                    startAngle:-M_PI_2 + M_PI * 2 * self.progress endAngle: -M_PI_2 clockwise:YES];
    }
    
    
    [path addLineToPoint:CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5)];
    [path closePath];
    CGContextAddPath(context, path.CGPath);
    [[UIColor whiteColor] setFill];
    CGContextFillPath(context);
    
    
    //
    CGFloat cubeLen = 25;
    CGRect cubeRect = CGRectMake((rect.size.width - cubeLen) * 0.5, (rect.size.height - cubeLen) * 0.5, cubeLen, cubeLen);
    path = [UIBezierPath bezierPathWithRoundedRect:cubeRect cornerRadius:2];
    CGContextAddPath(context, path.CGPath);
    [[UIColor redColor] setFill];
    CGContextFillPath(context);
    
}

@end
