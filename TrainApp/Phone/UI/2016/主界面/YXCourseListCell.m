//
//  YXCourseListCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseListCell.h"

@interface YXCourseListCell()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *historyImageView;
@property (nonatomic, strong) UILabel *recordLabel;
@end

@implementation YXCourseListCell

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

- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.courseImageView = [[UIImageView alloc]init];
    self.courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImageView.clipsToBounds = YES;
    self.courseImageView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 84));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-20);
    }];
    self.historyImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.historyImageView];
    [self.historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11];
    self.recordLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.historyImageView.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.historyImageView.mas_centerY);
        make.right.mas_equalTo(-20);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
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
    if (!_course.isSupportApp.boolValue) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.historyImageView.image = [UIImage imageNamed:@"不支持"];
        self.recordLabel.text = @"暂不支持该类型课程";
        self.recordLabel.textColor = [UIColor colorWithHexString:@"cdd2d9"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"cdd2d9"];
    }else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.recordLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        int second = _course.record.intValue;
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
    
    

}

@end
