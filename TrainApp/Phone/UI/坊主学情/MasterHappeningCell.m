//
//  MasterHappeningCell.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHappeningCell.h"
@interface MasterHappeningCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterHappeningCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    [self.explainButton addTarget:self action:@selector(explainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.explainButton];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:12.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
    [self.contentView addSubview:self.lineView];

}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(7.0f - 10.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f + 20.0f, 19.0f + 20.0f));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.greaterThanOrEqualTo(self.explainButton.mas_right).offset(10.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];

}
#pragma mark - button
- (void)explainButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.MasterHappeningCellButtonBlock,sender);
}
#pragma mark - set
- (void)setDetail:(MasterStatRequestItem_Body_Type_Detail *)detail {
    _detail = detail;
    self.titleLabel.text = [NSString stringWithFormat:@"%@  (%@分)",_detail.typecode,_detail.score];
    self.contentLabel.attributedText = [self formatContentAttributed:_detail.userscore];
    self.explainButton.hidden = isEmpty(_detail.descripe);
}
- (NSMutableAttributedString *)formatContentAttributed:(NSString *)userscore {
    NSString *completeStr = [NSString stringWithFormat:@"%@分",userscore];
    NSRange range = [completeStr rangeOfString:userscore];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_DemiBold size:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"e5581a"]} range:range];
    return attr;
}
@end
