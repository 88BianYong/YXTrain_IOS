//
//  MasterManageActiveListCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageActiveListCell_17.h"
@interface MasterManageActiveListCell_17 ()
@property (nonatomic, strong) UIImageView *activityImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *segmentLabel;
@property (nonatomic, strong) UILabel *studyLabel;
@property (nonatomic, strong) UILabel *isJoinLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *joinCountLabel;

@end
@implementation MasterManageActiveListCell_17


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.isJoinLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    self.joinCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    // Configure the view for the selected state
};
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.isJoinLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    self.joinCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
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
    [self.contentView addSubview:self.activityImageView];

    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];

    
    self.segmentLabel = [[UILabel alloc]init];
    self.segmentLabel.font = [UIFont systemFontOfSize:11];
    self.segmentLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.segmentLabel];

    
    self.studyLabel = [[UILabel alloc]init];
    self.studyLabel.font = [UIFont systemFontOfSize:11];
    self.studyLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.studyLabel];

    
    self.isJoinLabel = [[UILabel alloc]init];
    self.isJoinLabel.font = [UIFont systemFontOfSize:10];
    self.isJoinLabel.layer.cornerRadius = 3;
    self.isJoinLabel.layer.masksToBounds = YES;
    self.isJoinLabel.textColor = [UIColor whiteColor];
    self.isJoinLabel.text = @"已参加";
    self.isJoinLabel.textAlignment = NSTextAlignmentCenter;
    self.isJoinLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    [self.contentView addSubview:self.isJoinLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.timeLabel];

    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];

    self.joinCountLabel = [[UILabel alloc]init];
    self.joinCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.joinCountLabel.textColor = [UIColor whiteColor];
    self.joinCountLabel.textAlignment = NSTextAlignmentCenter;
    self.joinCountLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.activityImageView addSubview:self.joinCountLabel];
}
- (void)setupLayout {
    [self.activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 84));
    }];
    
    [self.isJoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activityImageView.mas_top).offset(5);
        make.left.equalTo(self.activityImageView.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(39, 15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImageView.mas_right).mas_offset(15);
        make.top.equalTo(self.activityImageView.mas_top).offset(4.0f);
        make.right.mas_equalTo(-20);
    }];
    [self.segmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9.0f);
    }];
    [self.studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLabel.mas_right).offset(15.0f);
        make.centerY.equalTo(self.segmentLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.segmentLabel.mas_bottom).offset(9.0f);
    }];
    
    [self.joinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.activityImageView.mas_centerX);
        make.height.mas_equalTo(20.0f);
        make.width.equalTo(self.activityImageView.mas_width);
        make.bottom.equalTo(self.activityImageView.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f);
    }];
}
- (void)setActive:(MasterManageActiveItem_Body_Active *)active {
    _active = active;
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:active.pic] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    self.titleLabel.text = active.title;
    self.segmentLabel.text = [NSString stringWithFormat:@"学段: %@",_active.segmentName];
    self.studyLabel.text = [NSString stringWithFormat:@"学科: %@",_active.studyName];
    self.isJoinLabel.hidden = !_active.isJoin.boolValue;
    if ([_active.source isEqualToString:@"zgjiaoyan"]) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"a1ae7a"];
    }else {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    if (_active.restrictTime.boolValue) {
        self.timeLabel.text = [NSString stringWithFormat:@"活动时间: %@-%@",_active.startTime,_active.endTime];
    }else {
        self.timeLabel.text = @"活动时间: 不限";
    }
    self.joinCountLabel.text = [NSString stringWithFormat:@"%@人参加",_active.joinUserCount];
}
@end
