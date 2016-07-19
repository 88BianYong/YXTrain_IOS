//
//  YXScoreTypeCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreTypeCell.h"

@interface YXScoreTypeCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXScoreTypeCell

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

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.typeImageView.mas_centerY);
    }];
}

- (void)setType:(YXScoreCellType)type{
    _type = type;
    if (type == YXScoreCellType_Lead) {
        self.typeImageView.image = [UIImage imageNamed:@"引领"];
        self.titleLabel.text = @"引领学习";
    }else{
        self.typeImageView.image = [UIImage imageNamed:@"拓展"];
        self.titleLabel.text = @"拓展学习";
    }
}

@end
