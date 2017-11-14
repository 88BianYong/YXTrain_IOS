//
//  YXProjectSelectionBgView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectSelectionBgView.h"

@interface YXProjectSelectionBgView()
@property (nonatomic, strong) YXTriangleView *triangleView;
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, assign) CGFloat triangleX;
@end

@implementation YXProjectSelectionBgView

- (instancetype)initWithFrame:(CGRect)frame triangleX:(CGFloat)x{
    if (self = [super initWithFrame:frame]) {
        self.triangleX = x;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
//    self.triangleView = [[YXTriangleView alloc]initWithFrame:CGRectMake(self.triangleX-8, 0, 16, 7)];
//    self.triangleView.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.triangleView];
//    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.triangleX-8);
//        make.top.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(16, 7));
//    }];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"切换项目名称的弹窗-尖角"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.triangleX-9);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 8));
    }];
    
    self.contentBgView = [[UIView alloc]init];
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    self.contentBgView.layer.cornerRadius = YXTrainCornerRadii;
    self.contentBgView.clipsToBounds = YES;
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom);
    }];
}

@end
