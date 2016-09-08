//
//  YXHotspotBaseCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotspotBaseCell.h"

@implementation YXHotspotBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.posterImageView = [[UIImageView alloc] init];
    self.posterImageView.backgroundColor = [UIColor redColor];
    self.posterImageView.layer.cornerRadius = YXTrainCornerRadii;
    self.posterImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.posterImageView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7];//调整行间距
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [course.course_title length])];
//    self.titleLabel.attributedText = attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
