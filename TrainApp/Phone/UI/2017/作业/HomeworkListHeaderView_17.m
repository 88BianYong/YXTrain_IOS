//
//  HomeworkListHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListHeaderView_17.h"
@interface HomeworkListHeaderView_17 ()

@end
@implementation HomeworkListHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *vLineView = [[UIView alloc] init];
        vLineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
        vLineView.layer.cornerRadius = 1.0f;
        [self.contentView addSubview:vLineView];
        [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.size.mas_offset(CGSizeMake(2.0f, 13.0f));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"考核要求";
        label.tag = 10086;
        label.textColor = [UIColor colorWithHexString:@"#334466"];
        label.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vLineView.mas_right).offset(7.0f);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIView *hLineView = [[UIView alloc] init];
        hLineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self.contentView addSubview:hLineView];
        [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}
#pragma mark - set
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    UILabel *label = [self.contentView viewWithTag:10086];
    label.text = _titleString;
}

@end
