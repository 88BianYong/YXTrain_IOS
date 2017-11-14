//
//  ProjectChooseLayerCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectChooseLayerCell.h"
@interface ProjectChooseLayerCell ()
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *descrLabel;
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation ProjectChooseLayerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLable.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLable];
    
    self.descrLabel = [[UILabel alloc] init];
    self.descrLabel.font = [UIFont systemFontOfSize:13.0f];
    self.descrLabel.numberOfLines = 0;
    self.descrLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.descrLabel];
    
    self.chooseImageView = [[UIImageView alloc] init];
    self.chooseImageView.image = [UIImage imageNamed:@"未选择"];
    [self.contentView addSubview:self.chooseImageView];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(23.5f);
        make.right.equalTo(self.contentView.mas_right).offset(-50.0f);
        make.top.equalTo(self.contentView.mas_top).offset(23.0f);
    }];
    
    [self.descrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(23.5f);
        make.right.equalTo(self.contentView.mas_right).offset(-50.0f);
        make.top.equalTo(self.titleLable.mas_bottom).offset(9.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-23.0f);
    }];
    
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30.5f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}
-(void)setItem:(TrainLayerListRequestItem_Body *)item {
    _item = item;
    self.titleLable.text = _item.title;
    self.descrLabel.text = _item.descr;
    self.chooseImageView.image = [UIImage imageNamed:_item.isChoose.boolValue ? @"选择" : @"未选择"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
