//
//  BeijingCourseListCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCourseListCell.h"
@interface BeijingCourseListCell ()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UIImageView *historyImageView;
@property (nonatomic, strong) UIImageView *hoursImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *hoursLabel;
@end

@implementation BeijingCourseListCell

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
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.courseImageView = [[UIImageView alloc]init];
    self.courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImageView.clipsToBounds = YES;
    self.courseImageView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:self.courseImageView];

    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.numberOfLines = 0.0f;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.hoursImageView = [[UIImageView alloc] init];
    self.hoursImageView.image = [UIImage imageNamed:@"学时icon"];
    [self.contentView addSubview:self.hoursImageView];
    self.hoursLabel = [[UILabel alloc] init];
    self.hoursLabel.font = [UIFont systemFontOfSize:11.0f];
    self.hoursLabel.text = @"学时 12.5";
    self.hoursLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.hoursLabel];
    
    self.historyImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.historyImageView];
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11];
    self.recordLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.recordLabel];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

- (void)setupLayout {
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.size.mas_equalTo(CGSizeMake(112.0f, 84.0f));
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15.0f);
        make.top.mas_equalTo(10.0f).priorityHigh();
        make.right.mas_equalTo(-20.0f);
    }];
    
    [self.hoursImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseImageView.mas_right).offset(12.0f);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.centerY.equalTo(self.hoursLabel.mas_centerY);
    }];
    [self.hoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hoursImageView.mas_right).offset(3.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.0f).priorityHigh();
    }];

    [self.historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(12.0f);
        make.centerY.equalTo(self.recordLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
    }];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.historyImageView.mas_right).mas_offset(3.0f);
        make.top.mas_equalTo(self.hoursLabel.mas_bottom).mas_offset(8.0f).priorityHigh();
        make.right.mas_equalTo(-20.0f);
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-15.0f).priorityLow();
    }];
}

- (void)setCourse:(YXCourseListRequestItem_body_module_course *)course{
    _course = course;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:course.course_img] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:course.course_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];//调整行间距
    paragraphStyle.minimumLineHeight = 20;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [course.course_title length])];
    self.titleLabel.attributedText = attributedString;
    self.hoursLabel.text = [NSString stringWithFormat:@"学时 %0.1f", _course.credit.doubleValue];
    int second = course.record.intValue;
    if (second == 0) {
        self.recordLabel.text = @"未观看";
        self.historyImageView.image = [UIImage imageNamed:@"未观看时间icon"];
    }else{
        int minute = second / 60;
        int hour = minute / 60;
        minute = minute % 60;
        second = second % 60;
        self.recordLabel.text = [NSString stringWithFormat:@"已观看 %02d:%02d:%02d", hour, minute, second];
        self.historyImageView.image = [UIImage imageNamed:@"已观看时间icon"];
    }
}
@end
