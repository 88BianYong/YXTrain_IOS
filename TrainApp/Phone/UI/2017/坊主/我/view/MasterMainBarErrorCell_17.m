//
//  MasterMainBarErrorCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterMainBarErrorCell_17.h"

@implementation MasterMainBarErrorCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        titleLabel.text = @"糟糕加载失败";
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_centerY).offset(-5.0f);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textColor = [UIColor colorWithHexString:@"c2c7ce"];
        subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        subTitleLabel.text = @"点击屏幕,重新加载";
        [self.contentView addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(titleLabel.mas_bottom).offset(7.0f);
        }];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
