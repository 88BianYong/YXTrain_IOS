//
//  YXLearningChannelHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningChannelHeaderView_17.h"

@implementation YXLearningChannelHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.tag = 10086;
        nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
        nameLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        WEAK_SELF
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            BLOCK_EXEC(self.learningChannelButtonCompleteBlock,self.mockOther);
        }];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];        
    }
    return self;
}
- (void)setMockOther:(ExamineDetailRequest_17Item_MockOther *)mockOther {
    _mockOther = mockOther;
    UILabel *label = [self.contentView viewWithTag:10086];
    label.text = _mockOther.otherName;
    if (_mockOther.otherType.integerValue == 1) {
        label.textColor = [UIColor colorWithHexString:@"334466"];
     }else {
        label.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    }
}
@end
