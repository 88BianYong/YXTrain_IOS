//
//  YXSideTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSideTableViewCell.h"

@interface YXSideTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *sideLabel;

@end

@implementation YXSideTableViewCell

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
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    
    self.sideLabel = [[UILabel alloc] init];
    self.sideLabel.font = [UIFont boldSystemFontOfSize:14];
    self.sideLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.sideLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.sideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(21);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)updateWithIconNamed:(NSString *)icon andName:(NSString *)name {
    self.iconImageView.image = [UIImage imageNamed:icon];
    self.sideLabel.text = name;
}

@end
