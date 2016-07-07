//
//  YXUserInfoTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUserInfoTableViewCell.h"

@interface YXUserInfoTableViewCell ()

@property (nonatomic, strong) UILabel *userTitleLabel;
@property (nonatomic, strong) UIButton *contentButton;

@end

@implementation YXUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.userTitleLabel = [[UILabel alloc] init];
    self.userTitleLabel.textAlignment = NSTextAlignmentRight;
    self.userTitleLabel.font = [UIFont systemFontOfSize:14];
    self.userTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.userTitleLabel];
    
    self.contentButton = [[UIButton alloc] init];
    [self.contentButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    self.contentButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.contentButton];
    
    [self.userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.userTitleLabel.mas_right).offset(14);
    }];
}

- (void)configUIwithTitle:(NSString *)title content:(NSString *)contentString {
    self.userTitleLabel.text = title;
    [self.contentButton setTitle:contentString forState:UIControlStateNormal];
}

@end
