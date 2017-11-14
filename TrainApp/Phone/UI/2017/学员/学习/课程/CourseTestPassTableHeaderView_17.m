//
//  CourseTestPassTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestPassTableHeaderView_17.h"
@interface CourseTestPassTableHeaderView_17 ()
@end
@implementation CourseTestPassTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *passLabel = [[UILabel alloc] init];
        passLabel.font = [UIFont systemFontOfSize:24.0f];
        passLabel.textColor = [UIColor colorWithHexString:@"7ab1e9"];
        passLabel.textAlignment = NSTextAlignmentCenter;
        passLabel.text = @"检测通过";
        [self addSubview:passLabel];
        [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(35.0f);
        }];

        UILabel *passRateLabel = [[UILabel alloc] init];
        passRateLabel.font = [UIFont systemFontOfSize:14.0f];
        passRateLabel.textColor = [UIColor colorWithHexString:@"7ab1e9"];
        passRateLabel.textAlignment = NSTextAlignmentCenter;
        passRateLabel.text = @"恭喜你答对所有题目,正确率100%";
        passRateLabel.tag = 10086;
        [self addSubview:passRateLabel];
        [passRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(passLabel.mas_bottom).offset(22.0f);
        }];
        
    }
    return self;
}
@end
