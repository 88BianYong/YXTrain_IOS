//
//  ShareResourcesTableViewCell.m
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ShareResourcesTableViewCell.h"
#import "YXDatumCellModel.h"
@interface ShareResourcesTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *uploadLabel;
@property (nonatomic, strong) UIView *cellSeperatorView;
@end

@implementation ShareResourcesTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.dateLabel];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.sizeLabel];
    
    self.uploadLabel = [[UILabel alloc]init];
    self.uploadLabel.font = [UIFont systemFontOfSize:12];
    self.uploadLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
//    self.uploadLabel.text = @"上传  王的拉萨";
    [self.contentView addSubview:self.uploadLabel];
    
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
        make.top.mas_equalTo(18);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(13);
        make.centerY.mas_equalTo(self.dateLabel);
        make.right.mas_lessThanOrEqualTo(20);
    }];
    [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-18);
    }];
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setCellModel:(YXDatumCellModel *)cellModel{
    _cellModel = cellModel;
    self.typeImageView.image = cellModel.image;
    self.titleLabel.text = cellModel.title;
    self.dateLabel.text = cellModel.date;
    self.sizeLabel.text = [BaseDownloader sizeStringForBytes:cellModel.size];
    self.typeImageView.image = cellModel.image;
    self.uploadLabel.text = [NSString stringWithFormat:@"上传  %@",cellModel.createUsername];
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
