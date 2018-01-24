//
//  MasterOffActiveRecordAffixCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveRecordAffixCell_17.h"
#import "BaseDownloader.h"
#import "YXAttachmentTypeHelper.h"
@interface MasterOffActiveRecordAffixCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIView *cellSeperatorView;
@end
@implementation MasterOffActiveRecordAffixCell_17

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.cellSeperatorView = [[UIView alloc]init];
    self.cellSeperatorView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.cellSeperatorView];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.greaterThanOrEqualTo(self.contentView.mas_top).offset(20.0f);
//        make.bottom.greaterThanOrEqualTo(self.contentView.mas_bottom).offset(15.0f);
    }];
    
    [self.cellSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f);
    }];
}
- (void)setAffix:(MasterManagerOffActiveDetailItem_Body_Affix *)affix {
    _affix = affix;
    self.titleLabel.text = _affix.resName;
    NSString *imageName = [YXAttachmentTypeHelper picNameWithTypeName:affix.resType];
    self.typeImageView.image = [UIImage imageNamed:imageName];
}
- (void)hiddenBottomView:(BOOL)hidden {
    self.cellSeperatorView.hidden = hidden;
}
@end
