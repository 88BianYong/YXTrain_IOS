//
//  YXCourseDetailCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailCell.h"
@interface YXCourseDetailCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXCourseDetailCell

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
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.cellStatus = self.cellStatus;
}
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.typeImageView = [[UIImageView alloc]init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d视频播放",i + 1]];
        [imageArray addObject:image];
    }
    self.typeImageView.animationImages = imageArray;
    self.typeImageView.animationDuration = 1.15;
    self.typeImageView.animationRepeatCount = 0;
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(12);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setData:(YXCourseDetailItem_chapter_fragment *)data{
    _data = data;
    self.typeImageView.image = [UIImage imageNamed:[YXAttachmentTypeHelper picNameWithID:data.type]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:data.fragment_name];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [data.fragment_name length])];
    self.titleLabel.attributedText = attributedString;
}
- (void)setCellStatus:(YXCourseDetailCellStatus)cellStatus {
    _cellStatus = cellStatus;
    [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    if (cellStatus == YXCourseDetailCellStatus_PLaying) {
        [self.typeImageView startAnimating];
        [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(23);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }else if (cellStatus == YXCourseDetailCellStatus_Watched) {
        [self.typeImageView stopAnimating];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }else {
        [self.typeImageView stopAnimating];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
}
@end
