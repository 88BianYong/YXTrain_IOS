//
//  YXMyLearningUserScoreView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyLearningUserScoreView.h"
@interface YXMyLearningUserScoreView ()

@end
@implementation YXMyLearningUserScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.scoreLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10.0f);
            make.centerX.equalTo(self.nameLabel.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
@end
