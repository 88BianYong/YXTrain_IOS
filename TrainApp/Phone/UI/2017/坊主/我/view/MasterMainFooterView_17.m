//
//  MasterMainFooterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterMainFooterView_17.h"
@interface MasterMainFooterView_17 ()
@end
@implementation MasterMainFooterView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.logoutButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.logoutButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
        [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.logoutButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.logoutButton];
        [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
