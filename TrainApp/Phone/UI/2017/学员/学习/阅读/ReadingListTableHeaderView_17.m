//
//  ReadingListTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReadingListTableHeaderView_17.h"

@implementation ReadingListTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *vLineView = [[UIView alloc] init];
        vLineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
        vLineView.layer.cornerRadius = 1.0f;
        [self addSubview:vLineView];
        [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.size.mas_offset(CGSizeMake(2.0f, 13.0f));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"考核要求";
        label.textColor = [UIColor colorWithHexString:@"#334466"];
        label.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vLineView.mas_right).offset(7.0f);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIView *hLineView = [[UIView alloc] init];
        hLineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self addSubview:hLineView];
        [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}
@end
