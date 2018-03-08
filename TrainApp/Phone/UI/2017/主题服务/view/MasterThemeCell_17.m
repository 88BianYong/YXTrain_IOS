//
//  MasterThemeCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterThemeCell_17.h"
@interface MasterThemeCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterThemeCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setTheme:(MasterThemeListItem_Body_Theme *)theme {
    _theme = theme;
    self.titleLabel.text = _theme.title;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_theme.descr?:@""];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _theme.descr.length)];
    self.contentLabel.attributedText = attributedString;
    if (_theme.isSelected.integerValue == 1) {
        self.chooseImageView.image = [UIImage imageNamed:@"选中"];
    }else {
        self.chooseImageView.image = [UIImage imageNamed:@"未选中"];
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.chooseImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.chooseImageView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(23.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-30.0f - 20.0f - 65.0f);
        make.top.equalTo(self.contentView.mas_top).offset(22.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(22.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-30.0f - 20.0f - 65.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-25.0f);
    }];
    
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_offset(1.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
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
