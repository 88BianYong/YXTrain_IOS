//
//  YXWorkshopDetailDatumCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDetailDatumCell.h"
@interface YXWorkshopDetailDatumCell()
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIImageView *_imageView;
}
@end
@implementation YXWorkshopDetailDatumCell

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
        _imageView.image = [UIImage imageNamed:@"工作坊列表展开箭头"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _imageView.image = [UIImage imageNamed:@"工作坊列表展开箭头-点击态"];
    }
    else{
        _imageView.image = [UIImage imageNamed:@"工作坊列表展开箭头"];
    }
}

#pragma mark - UI setting
- (void)setupUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _contentLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:_contentLabel];
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
}

- (void)layoutInterface{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self->_imageView.mas_left).offset(-10.0f);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.height.width.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}
- (void)reloadWithTitle:(NSString *)titleString
                content:(NSString *)contentString{
    _titleLabel.text = titleString;
    _contentLabel.text = contentString;
}
@end
