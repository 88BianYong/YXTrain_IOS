//
//  YXScanQRBackgroundView.m
//  YanXiuApp
//
//  Created by 李五民 on 15/10/12.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXScanQRBackgroundView.h"
@interface YXScanQRBackgroundView (){
    NSInteger _scanCount;
    UIImageView *_scanLineImageView;
}
@end
@implementation YXScanQRBackgroundView
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:0.8] setFill];
    CGContextFillRect(ctx, rect);
    CGContextClearRect(ctx, CGRectMake(50 + 0.5, 50 + 0.5, [[UIScreen mainScreen] bounds].size.width - 100 - 1, [[UIScreen mainScreen] bounds].size.width - 100 - 1));
}

- (id)init{
    self = [super init];
    if (self) {
        _scanCount =0;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor clearColor];
    middleView.layer.borderWidth = 0.5;
    
    middleView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6] CGColor];
    [self addSubview:middleView];
    
    _scanLineImageView = [[UIImageView alloc] init];
    _scanLineImageView.image = [UIImage imageNamed:@"扫描"];
    [self addSubview:_scanLineImageView];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 10086;
    titleLabel.numberOfLines = 2;
    NSString *string = @"将二维码放入扫描框内\n扫描后将自动登录手机研修";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    titleLabel.attributedText = attributedString;
    titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(50);
        make.leading.equalTo(self.mas_leading).offset(50);
        make.trailing.equalTo(self.mas_trailing).offset(-50);
        make.height.equalTo(middleView.mas_width);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIImage *rightUp = [UIImage imageNamed:@"方角"];
    
    UIImageView *leftUpImageView = [[UIImageView alloc] init];
    leftUpImageView.image = [UIImage imageWithCGImage:rightUp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationLeft];
    [self addSubview:leftUpImageView];
    [leftUpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top);
        make.leading.equalTo(middleView.mas_leading);
    }];
    
    UIImageView *rightUpImageView = [[UIImageView alloc] init];
    rightUpImageView.image = rightUp;;
    [self addSubview:rightUpImageView];
    [rightUpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top);
        make.trailing.equalTo(middleView.mas_trailing);
    }];
    
    UIImageView *leftDownImageView = [[UIImageView alloc] init];
    leftDownImageView.image = [UIImage imageWithCGImage:rightUp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationDown];;
    [self addSubview:leftDownImageView];
    [leftDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(middleView.mas_bottom);
        make.leading.equalTo(middleView.mas_leading);
    }];
    
    UIImageView *rightDownImageView = [[UIImageView alloc] init];
    rightDownImageView.image = [UIImage imageWithCGImage:rightUp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationRight];;
    [self addSubview:rightDownImageView];
    [rightDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(middleView.mas_bottom);
        make.trailing.equalTo(middleView.mas_trailing);
    }];
}

-(void)scanAnimation
{
    _scanCount ++;
    _scanLineImageView.frame = CGRectMake(50 + 0.5, 50 +_scanCount, [UIScreen mainScreen].bounds.size.width - 100 - 1, 2);
    if (_scanCount >= [UIScreen mainScreen].bounds.size.width - 100) {
        _scanCount = 0;
    }
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _titleString.length)];
    UILabel *label = [self viewWithTag:10086];
    label.attributedText = attributedString;
    label.textAlignment = NSTextAlignmentCenter;
}
@end
