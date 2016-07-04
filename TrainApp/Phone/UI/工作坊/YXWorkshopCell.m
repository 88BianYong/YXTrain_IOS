//
//  YXWorkshopCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopCell.h"
@interface YXWorkshopCell()
{
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UIImageView *_nextImageView;
}
@end

@implementation YXWorkshopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self layoutInterface];
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
- (void)setupUI{
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:_nameLabel];
    
    _nextImageView = [[UIImageView alloc] init];
    _nextImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_nextImageView];
}
- (void)layoutInterface{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.width.height.offset(40.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(11.0f);
        make.right.equalTo(_nextImageView.mas_left).offset(10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [_nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.offset(16.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
    }];
}
- (void)reloadWithText:(NSString *)text
              imageUrl:(NSString *)imageUrl{
    _nameLabel.text = text;
}
@end
