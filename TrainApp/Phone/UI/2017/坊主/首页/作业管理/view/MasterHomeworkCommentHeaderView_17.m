//
//  MasterHomeworkCommentHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkCommentHeaderView_17.h"

@implementation MasterHomeworkCommentHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"334466"];
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.text = @"评语";
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.top.equalTo(self.contentView.mas_top).offset(23.0f);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
