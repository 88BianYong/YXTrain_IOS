//
//  MasterOverallRatingListHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingListHeaderView_17.h"

@implementation MasterOverallRatingListHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"85898f"];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}
@end
