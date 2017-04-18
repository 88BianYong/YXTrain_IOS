//
//  NoticeAndBriefDetailHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeAndBriefDetailHeaderView.h"
@interface NoticeAndBriefDetailHeaderView ()
@property (nonatomic, strong) UIView *lineView;
@end
@implementation NoticeAndBriefDetailHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.clipsToBounds = YES;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"b1b6bc"];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    stepLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    stepLabel.text = @"附件";
    stepLabel.tag = 10001;
    stepLabel.textAlignment = NSTextAlignmentCenter;
    stepLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:stepLabel];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
        make.centerY.equalTo(stepLabel.mas_centerY);
    }];
    
    [stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(44.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(100.0f);
    }];
}
@end
