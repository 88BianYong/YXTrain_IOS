//
//  YXHotspotWordsCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotspotWordsCell.h"

@implementation YXHotspotWordsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutInterface];
    }
    return self;
}

#pragma mark - layout
- (void)layoutInterface{
    [self.posterImageView removeFromSuperview];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(20.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-21.0f);
    }];
    
}
@end
