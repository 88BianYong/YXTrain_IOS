//
//  ProjectEndTimeFloatingView_16.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectEndTimeFloatingView_16.h"

@implementation ProjectEndTimeFloatingView_16

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUIAndLayoutInterface];
    }
    return self;
}

- (void)setupUIAndLayoutInterface{
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.cornerRadius = 7.0f;
    containerView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:containerView];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = @"老师您好,本项目已结束,您可以继续\n学习,但个人学习成绩不在发生变化";
    label.numberOfLines = 2;
    label.textColor = [UIColor whiteColor];
    [containerView addSubview:label];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_offset(150.0f);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
@end
