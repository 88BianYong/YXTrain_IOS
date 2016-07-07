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
    self.triangleView = [[YXTriangleView alloc]initWithFrame:CGRectMake(self.triangleX-8, 0, 16, 7)];
    self.triangleView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.triangleView];
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.triangleX-8);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(16, 7));
    }];
    
    self.contentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, self.bounds.size.width, self.bounds.size.height-7)];
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    self.contentBgView.layer.cornerRadius = 2;
    self.contentBgView.clipsToBounds = YES;
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(7);
    }];
}

@end
