//
//  SecondCommentFooterView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "SecondCommentFooterView.h"

@implementation SecondCommentFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 200.0f, 30.0f)];
    label.textColor = [UIColor colorWithHexString:@"334466"];
    label.text = @"126条回复";
    label.font = [UIFont systemFontOfSize:13.0f];
    label.tag = 1000;
    [self.contentView addSubview:label];
}

- (void)setReplyNumber:(NSInteger)replyNumber {
    UILabel *label = [self.contentView viewWithTag:1000];
    label.text = [NSString stringWithFormat:@"%ld条回复",(long)replyNumber];
}
@end
