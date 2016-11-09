//
//  ActivityFilterCell.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterCell.h"

@interface ActivityFilterCell ()
@property (nonatomic, strong) UILabel *filterLabel;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ActivityFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    
    self.filterLabel = [[UILabel alloc]init];
    self.filterLabel.font = [UIFont systemFontOfSize:13];
    
    self.lineView  = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image = [UIImage imageNamed:@"选择对号"];
}
- (void)setupLayout {
    [self.contentView addSubview:self.filterLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.selectImageView];
    
    [self.filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
}
- (void)setFilterName:(NSString *)filterName {
    _filterName = filterName;
    self.filterLabel.text = filterName;
}
- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    if (isCurrent) {
        self.filterLabel.textColor = [UIColor colorWithHexString:@"0067be"];
        self.selectImageView.hidden = NO;
    }else{
        self.filterLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.selectImageView.hidden = YES;
    }
}
@end
