//
//  YXExamBlankHeaderFooterView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamBlankHeaderFooterView.h"
#import "YXProjectTimeView.h"
@implementation YXExamBlankHeaderFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    YXProjectTimeView *timeView = [[YXProjectTimeView alloc] init];
    [self.contentView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
