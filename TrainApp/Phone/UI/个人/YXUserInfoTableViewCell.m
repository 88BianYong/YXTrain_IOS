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
@property (nonatomic, strong) UILabel *contentLabel;

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
    [self.contentButton addTarget:self action:@selector(contentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.contentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.contentButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.contentButton];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentButton addSubview:self.contentLabel];
    
    [self.userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.userTitleLabel.mas_right).offset(14);
        make.right.mas_equalTo(-20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentButton.mas_left);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)configUIwithTitle:(NSString *)title content:(NSString *)contentString {
    self.userTitleLabel.text = title;
    self.contentLabel.text = contentString;
}

- (void)contentButtonClicked {
    if (self.userInfoButtonClickedBlock) {
        self.userInfoButtonClickedBlock();
    }
}

@end
