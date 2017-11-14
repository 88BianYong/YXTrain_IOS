//
//  YXExamNoScoreView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamNoScoreView.h"

@implementation YXExamNoScoreView

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
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(30);
    }];
    
    UIView *rv = [[UIView alloc]init];
    rv.backgroundColor = [UIColor colorWithHexString:@"ea8d63"];
    rv.layer.cornerRadius = 1;
    rv.clipsToBounds = YES;
    [self addSubview:rv];
    [rv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(13);
    }];
}

@end
