//
//  VideoPlayCommentEmptyView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/6/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoPlayCommentEmptyView.h"

@implementation VideoPlayCommentEmptyView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80.0f, 80.0f));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.imageView.mas_bottom).mas_offset(15.0f);
            make.bottom.equalTo(self.containerView.mas_bottom);
        }];
        self.backgroundColor = [UIColor whiteColor];
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-10.0f);
        }];
    }
    return self;
}
@end
