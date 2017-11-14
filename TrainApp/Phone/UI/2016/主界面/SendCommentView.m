//
//  SendCommentView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "SendCommentView.h"

@implementation SendCommentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    }
    return  self;
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d0d2d5"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发布评论 (500字以内) ...";
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.layer.cornerRadius = 16.0f;
    label.clipsToBounds = YES;
    label.tag = 10086;
    label.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    label.layer.borderColor = [UIColor colorWithHexString:@"d0d2d5"].CGColor;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_offset(32.0f);
    }];
}
- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    UILabel *label = [self viewWithTag:10086];
    label.text = _placeholderString;
}
@end
