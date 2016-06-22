//
//  YXAllDatumTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAllDatumTableViewCell.h"

@interface YXAllDatumTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIView *cellSeperatorView;
@end

@implementation YXAllDatumTableViewCell

- (void)awakeFromNib {
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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.typeImageView];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.dateLabel];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.sizeLabel];
    
    self.favorButton = [[UIButton alloc]init];
    self.favorButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.favorButton addTarget:self action:@selector(favorAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favorButton];
    
    self.seperatorView = [[UIView alloc]init];
    self.seperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:self.seperatorView];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:self.cellSeperatorView];
    
    [self.favorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.right.mas_equalTo(self.favorButton.mas_left);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.seperatorView.mas_left).mas_offset(-10);
    }];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeImageView);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeImageView);
        make.right.mas_lessThanOrEqualTo(self.seperatorView.mas_left).mas_offset(-10);
    }];
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setCellModel:(YXDatumCellModel *)cellModel{
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.dateLabel.text = cellModel.date;
    self.sizeLabel.text = cellModel.size;
    self.typeImageView.image = cellModel.image;
    
    if (cellModel.isFavor) {
        [self.favorButton setTitle:@"已保存" forState:UIControlStateNormal];
        [self.favorButton setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [self.favorButton setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateHighlighted];
    }else{
        [self.favorButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.favorButton setTitleColor:[UIColor colorWithHexString:@"2c97dd"] forState:UIControlStateNormal];
        [self.favorButton setTitleColor:[[UIColor colorWithHexString:@"2c97dd"] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    }
}

- (void)favorAction:(UIButton *)sender{
    if (self.cellModel.isFavor) {
        return;
    }
    if (self.allDatumCellFavor) {
        self.allDatumCellFavor();
    }
}

@end
