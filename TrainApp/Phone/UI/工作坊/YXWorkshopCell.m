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
        UIView *selectedBgView = [[UIView alloc]init];
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
        self.selectedBackgroundView = selectedBgView;
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
    if (!selected) {
        _nextImageView.image = [UIImage imageNamed:@"工作坊列表展开箭头"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _nextImageView.image = [UIImage imageNamed:@"工作坊列表展开箭头-点击态"];
    }
    else{
        _nextImageView.image = [UIImage imageNamed:@"工作坊列表展开箭头"];
    }
}
- (void)setupUI{
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"工作坊icon"];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:_nameLabel];
    
    _nextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_nextImageView];
}
- (void)layoutInterface{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14.0f);
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
