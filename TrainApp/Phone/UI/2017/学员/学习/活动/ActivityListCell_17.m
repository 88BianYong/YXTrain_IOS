//
//  ActivityListCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityListCell_17.h"
@interface ActivityListCell_17 ()
@property (nonatomic, strong) UIImageView *activityImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *isJoinLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *joinUserCountLabel;
@property (nonatomic, strong) UILabel *recommendLabel;
@end

@implementation ActivityListCell_17

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.isJoinLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    
    // Configure the view for the selected state
};
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.isJoinLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.activityImageView = [[UIImageView alloc]init];
    self.activityImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.activityImageView.clipsToBounds = YES;
    self.activityImageView.layer.cornerRadius = YXTrainCornerRadii;
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.font = [UIFont systemFontOfSize:11];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.statusLabel.text = @"进行中";
    
    self.joinUserCountLabel = [[UILabel alloc]init];
    self.joinUserCountLabel.font = [UIFont systemFontOfSize:11];
    self.joinUserCountLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.joinUserCountLabel.text = @"20人参与";
    
    self.isJoinLabel = [[UILabel alloc]init];
    self.isJoinLabel.font = [UIFont systemFontOfSize:10];
    self.isJoinLabel.layer.cornerRadius = 3;
    self.isJoinLabel.layer.masksToBounds = YES;
    self.isJoinLabel.textColor = [UIColor whiteColor];
    self.isJoinLabel.text = @"已参加";
    self.isJoinLabel.textAlignment = NSTextAlignmentCenter;
    self.isJoinLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    self.lineView = line;
    
    self.recommendLabel = [[UILabel alloc] init];
    self.recommendLabel.font = [UIFont systemFontOfSize:11.0f];
    self.recommendLabel.textColor = [UIColor colorWithHexString:@"f0a180"];
    self.recommendLabel.text = @"专家推荐";
}
- (void)setupLayout {
    [self.contentView addSubview:self.activityImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.joinUserCountLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.recommendLabel];
    
    [self.activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 84));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImageView.mas_right).mas_offset(15);
        make.top.equalTo(self.contentView).offset(16.0f);
        make.right.mas_equalTo(-20);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9.0f);
    }];
    [self.joinUserCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right).offset(15.0f);
        make.centerY.equalTo(self.statusLabel);
        make.right.equalTo(self.contentView);
    }];
    
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(9.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}
- (void)setActivity:(ActivityListRequestItem_body_activity *)activity {
    _activity = activity;
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:activity.pic] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    self.titleLabel.text = activity.title;
    self.statusLabel.text = [self showStatusContentWithStatus:activity.status];
    self.joinUserCountLabel.text = [NSString stringWithFormat:@"%@人参与",activity.joinUserCount];
    if ([activity.isJoin isEqualToString:@"1"]) {
        [self.contentView addSubview:self.isJoinLabel];
        [self.isJoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityImageView.mas_top).offset(5);
            make.left.equalTo(self.activityImageView.mas_left).offset(5);
            make.size.mas_equalTo(CGSizeMake(39, 15));
        }];
    }else {
        [self.isJoinLabel removeFromSuperview];
    }
    self.titleLabel.text = activity.title;
    if ([activity.source isEqualToString:@"zgjiaoyan"]) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"a1ae7a"];
    }
    self.recommendLabel.hidden = !_activity.isRecommend.boolValue;
    NSMutableAttributedString *titleLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];
    paragraphStyle.minimumLineHeight = 22;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [titleLabelAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleLabel.text length])];
    self.titleLabel.attributedText = titleLabelAttributedString;
}
- (NSString *)showStatusContentWithStatus:(NSString *)status {
    //0=未开始;2=进行中;3=已完成;4=阶段关闭-1=关闭;-2=草稿;-5=删除
    NSString *statusContent;
    switch (status.integerValue) {
        case -1:
            statusContent = @"已关闭";
            break;
        case 0:
            statusContent = @"未开始";
            break;
        case 2:
            statusContent = @"进行中";
            break;
        case 3:
            statusContent = @"已结束";
            break;
        case 4:
            statusContent = @"阶段关闭";
            break;
        default:
            break;
    }
    return statusContent;
}

@end
