//
//  YXScoreNoScoreView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreNoScoreView.h"

@implementation YXScoreNoScoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *lv = [[UIView alloc]init];
    lv.backgroundColor = [UIColor colorWithHexString:@"ea8d63"];
    lv.layer.cornerRadius = 1;
    lv.clipsToBounds = YES;
    [self addSubview:lv];
    [lv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
