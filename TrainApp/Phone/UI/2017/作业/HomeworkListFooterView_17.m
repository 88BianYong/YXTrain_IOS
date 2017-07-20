//
//  HomeworkListFooterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListFooterView_17.h"

@implementation HomeworkListFooterView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:headerView];
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self.contentView addSubview:bottomView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(bottomView.mas_top);
        }];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_offset(5.0f);
        }];
    }
    return self;
}
@end
