//
//  ActivityCommentHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/1/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityCommentHeaderView.h"

@implementation ActivityCommentHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:headerView];
}
@end
