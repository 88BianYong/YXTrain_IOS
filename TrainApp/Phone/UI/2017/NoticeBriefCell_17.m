//
//  NoticeBriefCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeBriefCell_17.h"
@interface NoticeBriefCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeNameLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation NoticeBriefCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setItem:(YXNoticeAndBulletinItem *)item {
    _item = item;
    self.titleLabel.text = _item.title;
    self.timeNameLabel.text = [NSString stringWithFormat:@"%@   by%@",_item.createDate,_item.userName];
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeNameLabel = [[UILabel alloc] init];
    self.timeNameLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.timeNameLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
    }];
    [self.timeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
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
