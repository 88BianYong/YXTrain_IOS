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
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.typeImageView];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.dateLabel];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.sizeLabel];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.cellSeperatorView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).offset(13);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-20);
    }];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11);
        make.bottom.equalTo(self.cellSeperatorView.mas_top).offset(-18);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.dateLabel);
        make.right.mas_lessThanOrEqualTo(20);
    }];
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setCellModel:(YXDatumCellModel *)cellModel{
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.dateLabel.text = cellModel.date;
    self.sizeLabel.text = [BaseDownloader sizeStringForBytes:cellModel.size];
    self.typeImageView.image = cellModel.image;
    if (cellModel.isFavor) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    } else {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
}

- (void)hiddenBottomView:(BOOL)hidden {
    self.cellSeperatorView.hidden = hidden;
}

@end
