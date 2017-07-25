//
//  CourseTestHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestHeaderView_17.h"

@implementation CourseTestHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"334455"];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.tag = 10086;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        UIView *hLineView = [[UIView alloc] init];
        hLineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self addSubview:hLineView];
        [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];

        self.typeInteger = 1;
    }
    return self;
}
- (void)setTypeInteger:(NSInteger)typeInteger {
    _typeInteger = typeInteger;
    UILabel *label = [self.contentView viewWithTag:10086];
    if (_typeInteger == 1) {
        label.text = @"单选题";
    }else if (_typeInteger == 2){
        label.text = @"多选题";
    }else {
        label.text = @"判断题";
    }
}
@end
