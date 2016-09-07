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
    if (!selected) {
        self.iconImageView.image = self.nameDictionary[@"normalIcon"] ? [UIImage imageNamed:self.nameDictionary[@"normalIcon"]] : nil;
        self.sideLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.iconImageView.image = self.nameDictionary[@"hightIcon"] ? [UIImage imageNamed:self.nameDictionary[@"hightIcon"]]:nil;
        self.sideLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }
    else{
        self.iconImageView.image = self.nameDictionary[@"normalIcon"] ? [UIImage imageNamed:self.nameDictionary[@"normalIcon"]] : nil;
        self.sideLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
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
- (void)setNameDictionary:(NSDictionary *)nameDictionary{
    _nameDictionary = nameDictionary;
    self.iconImageView.image = [UIImage imageNamed:self.nameDictionary[@"normalIcon"]];
    self.sideLabel.text = self.nameDictionary[@"title"];
}

@end
