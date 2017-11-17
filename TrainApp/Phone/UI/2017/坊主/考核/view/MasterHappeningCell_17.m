//
//  MasterHappeningCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHappeningCell_17.h"
@interface MasterHappeningCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *fenLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterHappeningCell_17

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态A"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态A"]
                        forState:UIControlStateHighlighted];
    [self.explainButton addTarget:self action:@selector(explainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.explainButton];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentLabel];
    
    self.fenLabel = [[UILabel alloc] init];
    self.fenLabel.font = [UIFont systemFontOfSize:12.0f];
    self.fenLabel.text = @"分";
    self.fenLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.fenLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.fenLabel];
    
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
        make.right.equalTo(self.fenLabel.mas_left).offset(-2.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.greaterThanOrEqualTo(self.explainButton.mas_right).offset(10.0f);
    }];
    [self.fenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-1.0f);
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
- (void)setDetail:(MasterIndexRequestItem_Body_MyExamine_Types_Detail *)detail {
    _detail = detail;
    self.titleLabel.text = [NSString stringWithFormat:@"%@  (%@分)",_detail.typecode,_detail.score];
    self.contentLabel.text = _detail.userscore;
    self.explainButton.hidden = isEmpty(_detail.descripe);
}
@end
