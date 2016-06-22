//
//  YXDatumOrderViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDatumOrderViewCell.h"

@interface YXDatumOrderViewCell()
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UIImageView *selectionImageView;
@property (nonatomic, strong) UIView *cellSeperatorView;
@end

@implementation YXDatumOrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.orderLabel = [[UILabel alloc]init];
    self.orderLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.orderLabel];
    
    self.selectionImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.selectionImageView];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:self.cellSeperatorView];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.selectionImageView.mas_left).mas_offset(-10);
    }];
    
    [self.selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setDatumOrder:(YXDatumOrder *)order{
    _datumOrder = order;
    self.orderLabel.text = order.name;
    if (order.selected) {
        self.selectionImageView.image = [UIImage imageNamed:@"icon_contact_selected"];
    }else{
        self.selectionImageView.image = [UIImage imageNamed:@"icon_contact_unselect"];
    }
}


@end
