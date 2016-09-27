//
//  YXEmptCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXEmptCell.h"

@implementation YXEmptCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(7.0f);
            make.width.mas_offset(7.0f);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
        [self.contentView addSubview:lineView];
        
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right).priorityLow();
            make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
        }];
        
    }
    return self;
}

@end
